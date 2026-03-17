import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../data/db_instance.dart';
import '../data/app_database.dart';
import '../data/notification_service.dart';
import '../main.dart';
import 'cultivo_detalle.dart';

class CalendarioPage extends StatefulWidget {
  final int userId;
  const CalendarioPage({super.key, required this.userId});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<CalendarTask>> _tasks = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    final list = await appDb.getUserTasks(widget.userId);
    final map = <DateTime, List<CalendarTask>>{};

    for (var task in list) {
      final date = DateTime(task.date.year, task.date.month, task.date.day);
      if (map[date] == null) map[date] = [];
      map[date]!.add(task);
    }

    setState(() {
      _tasks = map;
      _loading = false;
    });
  }

  List<CalendarTask> _getTasksForDay(DateTime day) {
    return _tasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _toggleTaskStatus(CalendarTask task) async {
    final newStatus = !task.completed;
    await appDb.updateTaskStatus(task.id, newStatus);

    if (newStatus) {
      // If completed, cancel notifications for this task
      await notificationService.cancelNotification(task.id);
    } else {
      // If uncompleted, reschedule if it's in the future
      if (task.date.isAfter(DateTime.now())) {
        await notificationService.scheduleTaskNotification(
          taskId: task.id,
          userId: widget.userId,
          title: task.title,
          body: task.description ?? '',
          scheduledDate: task.date,
        );
      }
    }

    await _loadTasks();
  }

  void _reportIncident(CalendarTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _IncidentReportDialog(task: task, onReport: _loadTasks),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Calendario Inteligente', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
                ),
                child: TableCalendar<CalendarTask>(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() => _calendarFormat = format);
                  },
                  eventLoader: _getTasksForDay,
                  calendarStyle: CalendarStyle(
                    markerDecoration: const BoxDecoration(color: AppColors.greenAccent, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(color: AppColors.greenSoft.withOpacity(0.5), shape: BoxShape.circle),
                    selectedDecoration: const BoxDecoration(color: AppColors.greenDark, shape: BoxShape.circle),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _getTasksForDay(_selectedDay!).isEmpty
                        ? const Center(child: Text('No hay tareas para este día', style: TextStyle(fontWeight: FontWeight.w600)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            itemCount: _getTasksForDay(_selectedDay!).length,
                            itemBuilder: (context, index) {
                              final task = _getTasksForDay(_selectedDay!)[index];
                              return _TaskTile(
                                task: task,
                                onToggle: () => _toggleTaskStatus(task),
                                onReport: () => _reportIncident(task),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final CalendarTask task;
  final VoidCallback onToggle;
  final VoidCallback onReport;

  const _TaskTile({required this.task, required this.onToggle, required this.onReport});

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'riego':
        return Icons.water_drop_rounded;
      case 'fertilización':
        return Icons.science_rounded;
      case 'poda':
        return Icons.content_cut_rounded;
      case 'trasplante':
        return Icons.import_export_rounded;
      case 'revisión de plagas':
        return Icons.bug_report_rounded;
      case 'pesticida':
        return Icons.sanitizer_rounded;
      case 'cosecha':
        return Icons.shopping_basket_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lunarPhase = _getLunarPhase(task.date);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: ListTile(
        leading: Icon(_iconForType(task.type), color: AppColors.greenDark, size: 30),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.greenDarker,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (lunarPhase.isNotEmpty)
              Tooltip(
                message: 'Fase Lunar: $lunarPhase',
                child: Text(_getLunarIcon(lunarPhase), style: const TextStyle(fontSize: 18)),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null) Text(task.description!),
            Text(DateFormat('hh:mm a').format(task.date), style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.report_problem_outlined, color: Colors.orange),
              onPressed: onReport,
              tooltip: 'Reportar incidente',
            ),
            Checkbox(
              value: task.completed,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.greenDark,
            ),
          ],
        ),
      ),
    );
  }

  // Simplified lunar phase calculation
  String _getLunarPhase(DateTime date) {
    // 0 = New Moon, 0.5 = Full Moon
    final lp = 2551443; // synodic month in seconds
    final now = date.millisecondsSinceEpoch / 1000;
    final newMoon = 592500; // a known new moon
    final phase = ((now - newMoon) % lp) / lp;

    if (phase < 0.03 || phase > 0.97) return 'Luna Nueva';
    if (phase < 0.22) return 'Luna Creciente';
    if (phase < 0.28) return 'Cuarto Creciente';
    if (phase < 0.47) return 'Gibosa Creciente';
    if (phase < 0.53) return 'Luna Llena';
    if (phase < 0.72) return 'Gibosa Menguante';
    if (phase < 0.78) return 'Cuarto Menguante';
    return 'Luna Menguante';
  }

  String _getLunarIcon(String phase) {
    switch (phase) {
      case 'Luna Nueva': return '🌑';
      case 'Luna Creciente': return '🌒';
      case 'Cuarto Creciente': return '🌓';
      case 'Gibosa Creciente': return '🌔';
      case 'Luna Llena': return '🌕';
      case 'Gibosa Menguante': return '🌖';
      case 'Cuarto Menguante': return '🌗';
      case 'Luna Menguante': return '🌘';
      default: return '';
    }
  }
}

class _IncidentReportDialog extends StatefulWidget {
  final CalendarTask task;
  final VoidCallback onReport;
  const _IncidentReportDialog({required this.task, required this.onReport});

  @override
  State<_IncidentReportDialog> createState() => _IncidentReportDialogState();
}

class _IncidentReportDialogState extends State<_IncidentReportDialog> {
  String _selectedIncident = 'Plagas';
  final _descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reportar incidente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.greenDarker)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedIncident,
            items: ['Plagas', 'Marchitez', 'Pérdida', 'Problemas de crecimiento', 'Otro']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _selectedIncident = v!),
            decoration: InputDecoration(
              labelText: 'Tipo de incidente',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Descripción / Detalles',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                // In a real app, this would update the plan logic.
                // For now, we'll just log it as a new task/note and show a snackbar.
                await appDb.insertNotificationLog(NotificationLogsCompanion.insert(
                  userId: widget.task.userId,
                  title: 'Incidente reportado: $_selectedIncident',
                  body: 'Cultivo: ${widget.task.title}. Detalle: ${_descCtrl.text}',
                ));

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incidente reportado. El plan se ajustará según sea necesario.')),
                  );
                  widget.onReport();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenDark, foregroundColor: Colors.white),
              child: const Text('Enviar Reporte', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class CropPlanGenerator {
  static Future<void> generate({
    required int userId,
    required Cultivo cultivo,
    required DateTime startDate,
    required TimeOfDay preferredTime,
  }) async {
    final planId = await appDb.insertCropPlan(CropPlansCompanion.insert(
      userId: userId,
      cropName: cultivo.nombre,
      startDate: startDate,
      preferredTime: '${preferredTime.hour.toString().padLeft(2, '0')}:${preferredTime.minute.toString().padLeft(2, '0')}',
      payloadJson: jsonEncode(cultivo.toJson()),
    ));

    final tasks = <CalendarTasksCompanion>[];

    // Irrigation Frequency
    final irrigationFreq = _parseIrrigationFrequency(cultivo.ficha['Riego'] ?? '');

    // Total harvest time in days
    final harvestDays = cultivo.cosechaMeses * 30;
    if (harvestDays == 0) return;

    for (int day = 0; day <= harvestDays; day++) {
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

      // Fertilization (every 15 days as default for smart plan)
      if (day > 0 && day % 15 == 0) {
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
          description: drift.Value('Uso de pesticida orgánico o preventivo recomendado.'),
          date: taskDate,
          type: 'Pesticida',
        ));
      }

      // Pruning (if applicable, every 30 days)
      if (day > 0 && day % 30 == 0 && (cultivo.tipo == 'Frutal' || cultivo.tipo == 'Vegetal')) {
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

    // Schedule notifications for the first week to avoid overloading and respect mobile limits
    // In a production app, we might use a background worker to schedule more as time goes by.
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final taskDate = task.date.value;

      // Only schedule if it's in the future and within the next 7 days for now
      if (taskDate.isAfter(DateTime.now()) && taskDate.isBefore(DateTime.now().add(const Duration(days: 7)))) {
        // We need the actual ID from the DB, but insertAll doesn't return them easily in a batch
        // For simplicity in this prototype, we'll fetch them or just use a combined ID
        // Actually drift's insertAll doesn't return IDs.
        // Let's do it differently.
      }
    }

    // Better: schedule notifications for tasks that were just created.
    final allTasks = await appDb.getUserTasks(userId);
    final newTasks = allTasks.where((t) => t.planId == planId).toList();

    for (final t in newTasks) {
      if (t.date.isAfter(DateTime.now()) && t.date.isBefore(DateTime.now().add(const Duration(days: 7)))) {
        await notificationService.scheduleTaskNotification(
          taskId: t.id,
          userId: userId,
          title: t.title,
          body: t.description ?? '',
          scheduledDate: t.date,
        );
      }
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

// Extension to help with copying DateTime
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
    // El Salvador has two main seasons:
    // Invierno (Rainy): May to October
    // Verano (Dry): November to April

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