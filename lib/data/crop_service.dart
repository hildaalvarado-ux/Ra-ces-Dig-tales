import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'db_instance.dart';
import 'app_database.dart';
import 'notification_service.dart';
import 'crop_models.dart';

class CropPlanGenerator {
  static Future<void> generate({
    required int userId,
    required Cultivo cultivo,
    required DateTime startDate,
    required TimeOfDay preferredTime,
    String? nickname,
    int? colorValue,
    bool? isAlmacigoOverride,
    bool isRisk = false,
  }) async {
    try {
      final payload = cultivo.toJson();
      if (isRisk) {
        payload['isRisk'] = true;
      }

      final planId = await appDb.insertCropPlan(CropPlansCompanion.insert(
        userId: userId,
        cropName: cultivo.nombre,
        nickname: drift.Value(nickname),
        colorValue: drift.Value(colorValue),
        startDate: startDate,
        preferredTime: '${preferredTime.hour.toString().padLeft(2, '0')}:${preferredTime.minute.toString().padLeft(2, '0')}',
        payloadJson: jsonEncode(payload),
      ));

      final tasks = <CalendarTasksCompanion>[];

      // --- PHASE 1: PREPARATION & SOWING (First Week) ---
      final guia = cultivo.guiaRapida ?? {};

      // Day 0: Preparation
      tasks.add(CalendarTasksCompanion.insert(
        planId: drift.Value(planId),
        userId: userId,
        title: 'Preparación de tierra: ${cultivo.nombre}',
        description: drift.Value(guia['preparacionTierra'] ?? 'Preparar el suelo adecuadamente.'),
        date: startDate.copyWith(hour: preferredTime.hour, minute: preferredTime.minute),
        type: 'Preparación',
      ));

      // Day 1: Sowing
      final usesAlmacigo = isAlmacigoOverride ?? (guia['usaAlmacigo'] == true);

      tasks.add(CalendarTasksCompanion.insert(
        planId: drift.Value(planId),
        userId: userId,
        title: 'Siembra de ${cultivo.nombre}${usesAlmacigo ? ' (Almácigo)' : ' (Directa)'}',
        description: drift.Value(
          'Tipo: ${cultivo.ficha['Tipo de siembra'] ?? 'No especificado'}. '
          'Profundidad: ${cultivo.ficha['Profundidad de semilla'] ?? 'No especificado'}. '
          '${usesAlmacigo ? 'Sembrar en semilleros protegidos.' : 'Sembrar directamente en el sitio final.'} '
          '${guia['comoSembrar'] ?? ''}'
        ),
        date: startDate.add(const Duration(days: 1)).copyWith(hour: preferredTime.hour, minute: preferredTime.minute),
        type: 'Siembra',
      ));

      // Germination Care (Days 2-6)
      for (int d = 2; d <= 6; d++) {
        tasks.add(CalendarTasksCompanion.insert(
          planId: drift.Value(planId),
          userId: userId,
          title: 'Cuidados iniciales: ${cultivo.nombre}',
          description: drift.Value(guia['cuidadosGerminacion'] ?? 'Mantener humedad y proteger de climas extremos.'),
          date: startDate.add(Duration(days: d)).copyWith(hour: preferredTime.hour, minute: preferredTime.minute),
          type: 'Cuidado inicial',
        ));
      }

      // --- PHASE 2: ALMACIGO & GROWTH ---
      int timeInAlmacigo = guia['tiempoAlmacigo'] ?? 0;

      if (usesAlmacigo && timeInAlmacigo > 0) {
        tasks.add(CalendarTasksCompanion.insert(
          planId: drift.Value(planId),
          userId: userId,
          title: 'Evaluación de trasplante: ${cultivo.nombre}',
          description: drift.Value('Verificar si ya está lista para mover a su lugar definitivo. ${guia['senalesTrasplante'] ?? 'No especificado'}'),
          date: startDate.add(Duration(days: timeInAlmacigo)).copyWith(hour: preferredTime.hour, minute: preferredTime.minute),
          type: 'Trasplante',
        ));
      }

      // --- PHASE 3: REGULAR MAINTENANCE ---
      final irrigationFreq = _parseIrrigationFrequency(cultivo.ficha['Riego'] ?? '');
      int harvestDays = cultivo.cosechaMeses * 30;
      if (harvestDays <= 0) {
        debugPrint('Advertencia: Cosecha en 0 meses para ${cultivo.nombre}. Usando 3 meses por defecto.');
        harvestDays = 90;
      }

      // Start maintenance after first week
      for (int day = 7; day <= harvestDays; day++) {
        final taskDate = startDate.add(Duration(days: day)).copyWith(
              hour: preferredTime.hour,
              minute: preferredTime.minute,
            );

        // Irrigation
        if (day % irrigationFreq == 0) {
          tasks.add(CalendarTasksCompanion.insert(
            planId: drift.Value(planId),
            userId: userId,
            title: 'Regar ${cultivo.nombre}',
            description: drift.Value('Riego programado según frecuencia del cultivo.'),
            date: taskDate,
            type: 'Riego',
          ));
        }

        // Fertilization
        if (day % 15 == 0) {
          tasks.add(CalendarTasksCompanion.insert(
            planId: drift.Value(planId),
            userId: userId,
            title: 'Fertilizar ${cultivo.nombre}',
            description: drift.Value('Aporte de nutrientes para crecimiento óptimo.'),
            date: taskDate,
            type: 'Fertilización',
          ));
        }

        // Pest control check (every 7 days)
        if (day % 7 == 0) {
          tasks.add(CalendarTasksCompanion.insert(
            planId: drift.Value(planId),
            userId: userId,
            title: 'Revisión de plagas: ${cultivo.nombre}',
            description: drift.Value('Checkeo visual de hojas y tallos.'),
            date: taskDate,
            type: 'Revisión de plagas',
          ));
        }

        // Pesticide recommendation (preventive every 21 days)
        if (day > 0 && day % 21 == 0) {
          tasks.add(CalendarTasksCompanion.insert(
            planId: drift.Value(planId),
            userId: userId,
            title: 'Aplicar preventivo: ${cultivo.nombre}',
            description: drift.Value('Uso de repelente orgánico o preventivo recomendado.'),
            date: taskDate,
            type: 'Pesticida',
          ));
        }

        // Pruning
        if (day % 30 == 0 && (cultivo.tipo == 'Frutal' || cultivo.tipo == 'Vegetal')) {
          tasks.add(CalendarTasksCompanion.insert(
            planId: drift.Value(planId),
            userId: userId,
            title: 'Poda de mantenimiento: ${cultivo.nombre}',
            description: drift.Value('Eliminar hojas secas o ramas innecesarias.'),
            date: taskDate,
            type: 'Poda',
          ));
        }
      }

      // Harvest task
      tasks.add(CalendarTasksCompanion.insert(
        planId: drift.Value(planId),
        userId: userId,
        title: 'COSECHA: ${cultivo.nombre}',
        description: drift.Value('¡Llegó el momento de cosechar tus frutos!'),
        date: startDate.add(Duration(days: harvestDays)).copyWith(hour: 8, minute: 0),
        type: 'Cosecha',
      ));

      await appDb.batch((batch) {
        batch.insertAll(appDb.calendarTasks, tasks);
      });

      final allTasks = await appDb.getUserTasks(userId);
      final newTasks = allTasks.where((t) => t.planId == planId).toList();

      for (final t in newTasks) {
        if (t.date.isAfter(DateTime.now()) && t.date.isBefore(DateTime.now().add(const Duration(days: 7)))) {
          try {
            await notificationService.scheduleTaskNotification(
              taskId: t.id,
              userId: userId,
              title: t.title,
              body: t.description ?? '',
              scheduledDate: t.date,
              colorValue: colorValue,
            );
          } catch (e) {
            debugPrint('Error al programar notificación para tarea ${t.id}: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error crítico en CropPlanGenerator.generate: $e');
      rethrow;
    }
  }

  static int _parseIrrigationFrequency(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('cada día') || lower.contains('diario')) return 1;
    if (lower.contains('cada 2 días')) return 2;
    if (lower.contains('cada 3 días')) return 3;
    if (lower.contains('semanal') || lower.contains('cada 7 días')) return 7;
    if (lower.contains('moderado')) return 3;
    if (lower.contains('frecuente')) return 1;
    return 2; // Default
  }
}

extension DateTimeExtension on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

class AgriculturalLogic {
  static String mapSeasonToElSalvador(String season) {
    switch (season.toLowerCase()) {
      case 'primavera':
        return 'Mayo - Junio (Inicio de Invierno)';
      case 'verano':
        return 'Noviembre - Enero (Verano)';
      case 'otoño':
        return 'Septiembre - Octubre (Fin de Invierno)';
      case 'invierno':
        return 'Julio - Agosto (Canícula o Invierno pleno)';
      default:
        return 'Todo el año';
    }
  }

  static List<String> getMonthsForSeason(String season) {
    switch (season.toLowerCase()) {
      case 'otoño': return ['Septiembre', 'Octubre'];
      case 'invierno': return ['Mayo', 'Junio', 'Julio', 'Agosto'];
      case 'primavera': return ['Abril', 'Mayo'];
      case 'verano': return ['Noviembre', 'Diciembre', 'Enero', 'Febrero', 'Marzo'];
      default: return [];
    }
  }
}
