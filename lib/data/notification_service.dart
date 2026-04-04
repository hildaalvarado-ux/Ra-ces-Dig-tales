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
    if (payload != null && !payload.startsWith('reminder_')) {
      final taskId = int.tryParse(payload);
      if (taskId != null) {
        appDb.updateNotificationStatusByTask(taskId, 'read');

        final userId = await appDb.getActiveUserId();
        if (userId != null) {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => CalendarioPage(userId: userId)),
          );
        }
      }
    } else if (payload != null && payload.startsWith('reminder_')) {
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

    // 2. 2-Hour Reminder
    final reminderDate = scheduledDate.add(const Duration(hours: 2));
    final tzReminderDate = tz.TZDateTime.from(reminderDate, tz.local);

    if (tzReminderDate.isAfter(now) && notificationsEnabled) {
      await _notificationsPlugin.zonedSchedule(
        id: taskId + 1000000,
        title: 'Pendiente: $title',
        body: 'No has marcado como completada la tarea: $title',
        scheduledDate: tzReminderDate,
        notificationDetails: fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            _getChannelId('cultivo_reminders', soundPref),
            'Recordatorios de Tareas',
            channelDescription:
                'Recordatorios si no se completa la tarea en 2 horas',
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
    }

    // 3. Nightly Reminder (8:00 PM)
    final nightlyDate = DateTime(
        scheduledDate.year, scheduledDate.month, scheduledDate.day, 20, 0);
    final tzNightlyDate = tz.TZDateTime.from(nightlyDate, tz.local);

    if (tzNightlyDate.isAfter(now) &&
        tzNightlyDate.isAfter(tzDate) &&
        notificationsEnabled) {
      await _notificationsPlugin.zonedSchedule(
        id: taskId + 2000000,
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
    }
  }

  Future<void> cancelNotification(int id) async {
    await Future.wait([
      _notificationsPlugin.cancel(id: id),
      _notificationsPlugin.cancel(id: id + 1000000),
      _notificationsPlugin.cancel(id: id + 2000000),
    ]);
  }

  Future<void> cancelAllNotificationsForPlan(int planId) async {
    final tasks = await appDb.getTasksByPlan(planId);
    // Parallelize cancellation for all tasks in the plan
    await Future.wait(tasks.map((t) => cancelNotification(t.id)));
  }
}

final notificationService = NotificationService();