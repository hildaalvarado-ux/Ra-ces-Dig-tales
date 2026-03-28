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

  Future<void> scheduleTaskNotification({
    required int taskId,
    required int userId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    int? colorValue,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    if (tzDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _notificationsPlugin.zonedSchedule(
      id: taskId,
      title: title,
      body: body,
      scheduledDate: tzDate,
      notificationDetails: fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'cultivo_tasks',
          'Tareas de Cultivo',
          channelDescription: 'Notificaciones para riego, fertilización, etc.',
          importance: fln.Importance.max,
          priority: fln.Priority.high,
          color: colorValue != null ? Color(colorValue) : null,
        ),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      payload: taskId.toString(),
    );

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

    // Schedule follow-up reminders
    final reminders = [
      {'offset': 2, 'id': 1000000},
      {'offset': 6, 'id': 2000000},
      {'offset': 10, 'id': 3000000},
    ];

    for (final r in reminders) {
      final reminderDate = scheduledDate.add(Duration(hours: r['offset'] as int));
      // Only schedule if it's still the same day as the original task
      if (reminderDate.day == scheduledDate.day) {
        final tzReminderDate = tz.TZDateTime.from(reminderDate, tz.local);
        if (tzReminderDate.isAfter(tz.TZDateTime.now(tz.local))) {
          await _notificationsPlugin.zonedSchedule(
            id: taskId + (r['id'] as int),
            title: 'Pendiente: $title',
            body: 'No has marcado como completada la tarea: $title',
            scheduledDate: tzReminderDate,
            notificationDetails: fln.NotificationDetails(
              android: fln.AndroidNotificationDetails(
                'cultivo_reminders',
                'Recordatorios de Tareas',
                channelDescription: 'Recordatorios si no se completa la tarea durante el día',
                importance: fln.Importance.high,
                priority: fln.Priority.high,
                color: colorValue != null ? Color(colorValue) : null,
              ),
            ),
            androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
            payload: 'reminder_$taskId',
          );
        }
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
    await _notificationsPlugin.cancel(id: id + 1000000); // 2h reminder
    await _notificationsPlugin.cancel(id: id + 2000000); // 6h reminder
    await _notificationsPlugin.cancel(id: id + 3000000); // 10h reminder
  }
}

final notificationService = NotificationService();