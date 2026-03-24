import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'db_instance.dart';

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

  void _onDidReceiveNotificationResponse(fln.NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && !payload.startsWith('reminder_')) {
      final taskId = int.tryParse(payload);
      if (taskId != null) {
        // Navigation logic is usually handled in the main app or via a navigator key
        // For this prototype, we'll assume the app will handle it if we store the state
        appDb.updateNotificationStatusByTask(taskId, 'read');
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

    // Save to logs
    await appDb.insertNotificationLog(NotificationLogsCompanion.insert(
      userId: userId,
      title: title,
      body: body,
      timestamp: Value(scheduledDate),
      taskId: Value(taskId),
      status: const Value('unread'),
    ));

    // Schedule 2-hour reminder
    final reminderDate = scheduledDate.add(const Duration(hours: 2));
    final tzReminderDate = tz.TZDateTime.from(reminderDate, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id: taskId + 1000000, // Unique ID for reminder
      title: 'Pendiente: $title',
      body: 'No has marcado como completada la tarea: $title',
      scheduledDate: tzReminderDate,
      notificationDetails: fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'cultivo_reminders',
          'Recordatorios de Tareas',
          channelDescription: 'Recordatorios si no se completa la tarea en 2 horas',
          importance: fln.Importance.high,
          priority: fln.Priority.high,
          color: colorValue != null ? Color(colorValue) : null,
        ),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'reminder_$taskId',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
    await _notificationsPlugin.cancel(id: id + 1000000); // Also cancel reminder
  }
}

final notificationService = NotificationService();