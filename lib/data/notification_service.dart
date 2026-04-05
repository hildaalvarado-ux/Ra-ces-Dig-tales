import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'db_instance.dart';
import '../main.dart';
import '../datos/calendario.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin = fln.FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    const fln.InitializationSettings initializationSettings = fln.InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request permissions for Android 13+
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  void _onDidReceiveNotificationResponse(fln.NotificationResponse response) async {
    final payload = response.payload;
    if (payload == null) return;

    final String taskIdStr = payload.startsWith('reminder_')
        ? payload.replaceFirst('reminder_', '')
        : payload;

    final taskId = int.tryParse(taskIdStr);
    if (taskId != null) {
      // Mark as read and cancel all further reminders for this specific task
      await appDb.updateNotificationStatusByTask(taskId, 'read');
      await cancelNotification(taskId);

      final userId = await appDb.getActiveUserId();
      if (userId != null) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => CalendarioPage(userId: userId)),
        );
      }
    }
  }

  fln.AndroidNotificationSound? _getSound(String? soundPref) {
    if (soundPref == null || soundPref == 'default') return null;
    if (soundPref == 'silent') return null; // Or something to indicate silence
    if (soundPref.contains('|')) {
      final uri = soundPref.split('|')[0];
      return fln.UriAndroidNotificationSound(uri);
    }
    return fln.RawResourceAndroidNotificationSound(soundPref);
  }

  String _getChannelId(String base, String? soundPref) {
    if (soundPref == null || soundPref == 'default') return base;
    // Android caches channel settings like sound. To change the sound, we need a new channel.
    // We create a hash of the sound name/uri to distinguish channels.
    final hash = soundPref.hashCode.abs().toString().padLeft(8, '0');
    return '${base}_$hash';
  }

  Future<void> scheduleTaskNotification({
    required int taskId,
    required int userId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    int? colorValue,
  }) async {
    final user = await appDb.getUserById(userId);
    final notificationsEnabled = user?.notificationsEnabled ?? true;
    final soundPref = user?.notificationSound;

    final now = tz.TZDateTime.now(tz.local);
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // 1. Primary Notification
    if (tzDate.isAfter(now) && notificationsEnabled) {
      await _notificationsPlugin.zonedSchedule(
        id: taskId,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            _getChannelId('cultivo_tasks', soundPref),
            'Tareas de Cultivo',
            channelDescription: 'Notificaciones para riego, fertilización, etc.',
            importance: soundPref == 'silent' ? fln.Importance.low : fln.Importance.max,
            priority: soundPref == 'silent' ? fln.Priority.low : fln.Priority.high,
            playSound: soundPref != 'silent',
            color: colorValue != null ? Color(colorValue) : null,
            sound: _getSound(soundPref),
          ),
        ),
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        payload: taskId.toString(),
      );
    }

    // Save to logs if not already exists
    final existing = await appDb.getUnreadLogByTask(taskId);
    if (existing == null) {
      await appDb.insertNotificationLog(NotificationLogsCompanion.insert(
        userId: userId,
        title: title,
        body: body,
        timestamp: Value(scheduledDate),
        taskId: Value(taskId),
        status: const Value('unread'),
      ));
    }

    // Periodic Reminders (3, 6, 9 hours later)
    for (int i = 1; i <= 3; i++) {
      final reminderDate = scheduledDate.add(Duration(hours: i * 3));
      final tzReminderDate = tz.TZDateTime.from(reminderDate, tz.local);

      if (tzReminderDate.isAfter(now) && notificationsEnabled) {
        final reminderId = taskId + (i * 1000000);
        await _notificationsPlugin.zonedSchedule(
          id: reminderId,
          title: 'Pendiente (${i * 3}h): $title',
          body: 'No has marcado como completada la tarea: $title',
          scheduledDate: tzReminderDate,
          notificationDetails: fln.NotificationDetails(
            android: fln.AndroidNotificationDetails(
              _getChannelId('cultivo_reminders', soundPref),
              'Recordatorios de Tareas',
              channelDescription: 'Recordatorios periódicos para tareas pendientes',
              importance: soundPref == 'silent' ? fln.Importance.low : fln.Importance.high,
              priority: soundPref == 'silent' ? fln.Priority.low : fln.Priority.high,
              playSound: soundPref != 'silent',
              color: colorValue != null ? Color(colorValue) : null,
              sound: _getSound(soundPref),
            ),
          ),
          androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'reminder_$taskId',
        );

        // Also add logs for reminders so they appear in the app's notification list when due
        await appDb.insertNotificationLog(NotificationLogsCompanion.insert(
          userId: userId,
          title: 'Recordatorio (${i * 3}h): $title',
          body: 'Aún tienes pendiente: $title',
          timestamp: Value(reminderDate),
          taskId: Value(taskId),
          status: const Value('unread'),
        ));
      }
    }

    // Nightly Reminder (8:00 PM)
    final nightlyDate = DateTime(
        scheduledDate.year, scheduledDate.month, scheduledDate.day, 20, 0);
    final tzNightlyDate = tz.TZDateTime.from(nightlyDate, tz.local);

    if (tzNightlyDate.isAfter(now) &&
        tzNightlyDate.isAfter(tzDate) &&
        notificationsEnabled) {
      final nightlyId = taskId + 4000000;
      await _notificationsPlugin.zonedSchedule(
        id: nightlyId,
        title: 'Gestión Pendiente: $title',
        body: 'Aún tienes esta tarea pendiente para hoy. ¡No la olvides!',
        scheduledDate: tzNightlyDate,
        notificationDetails: fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            _getChannelId('cultivo_nightly', soundPref),
            'Recordatorios Nocturnos',
            channelDescription: 'Aviso de tareas no realizadas al final del día',
            importance: soundPref == 'silent' ? fln.Importance.low : fln.Importance.high,
            priority: soundPref == 'silent' ? fln.Priority.low : fln.Priority.high,
            playSound: soundPref != 'silent',
            color: colorValue != null ? Color(colorValue) : null,
            sound: _getSound(soundPref),
          ),
        ),
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'reminder_$taskId',
      );

      await appDb.insertNotificationLog(NotificationLogsCompanion.insert(
        userId: userId,
        title: 'Gestión Nocturna: $title',
        body: 'Último aviso del día para: $title',
        timestamp: Value(nightlyDate),
        taskId: Value(taskId),
        status: const Value('unread'),
      ));
    }
  }

  Future<void> syncNotifications(int userId) async {
    // 1. Cancel all pending scheduled notifications
    await _notificationsPlugin.cancelAll();

    // 2. Fetch all future uncompleted tasks
    final now = DateTime.now();
    final tasks = await appDb.getUserTasks(userId);
    final futureTasks = tasks.where((t) => !t.completed && t.date.isAfter(now.subtract(const Duration(hours: 12)))).toList();

    // 3. Get plans for color info
    final plans = await appDb.getUserCropPlans(userId);
    final plansMap = {for (var p in plans) p.id: p};

    // 4. Clean up future notification logs to avoid duplicates before rescheduling
    // (Existing unread logs for these tasks that are in the future)
    final taskIds = futureTasks.map((t) => t.id).toList();
    if (taskIds.isNotEmpty) {
      await (appDb.delete(appDb.notificationLogs)
            ..where((t) => t.taskId.isIn(taskIds) & t.status.equals('unread') & t.timestamp.isBiggerOrEqualValue(now)))
          .go();
    }

    // 5. Reschedule
    for (final task in futureTasks) {
      final plan = plansMap[task.planId];
      await scheduleTaskNotification(
        taskId: task.id,
        userId: userId,
        title: task.title,
        body: task.description ?? '',
        scheduledDate: task.date,
        colorValue: plan?.colorValue,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await Future.wait([
      _notificationsPlugin.cancel(id: id),
      _notificationsPlugin.cancel(id: id + 1000000), // 3h
      _notificationsPlugin.cancel(id: id + 2000000), // 6h
      _notificationsPlugin.cancel(id: id + 3000000), // 9h
      _notificationsPlugin.cancel(id: id + 4000000), // Nightly
    ]);
  }

  Future<void> cancelAllNotificationsForPlan(int planId) async {
    final tasks = await appDb.getTasksByPlan(planId);
    // Parallelize cancellation for all tasks in the plan
    await Future.wait(tasks.map((t) => cancelNotification(t.id)));
  }
}

final notificationService = NotificationService();