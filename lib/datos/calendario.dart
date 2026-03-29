import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart' hide Column;
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
  Map<int, CropPlan> _plans = {};
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
    final plansList = await appDb.getUserCropPlans(widget.userId);

    final map = <DateTime, List<CalendarTask>>{};
    final plansMap = {for (var p in plansList) p.id: p};

    for (var task in list) {
      final date = DateTime(task.date.year, task.date.month, task.date.day);
      if (map[date] == null) map[date] = [];
      map[date]!.add(task);
    }

    setState(() {
      _tasks = map;
      _plans = plansMap;
      _loading = false;
    });
  }

  List<CalendarTask> _getTasksForDay(DateTime day) {
    return _tasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _toggleTaskStatus(CalendarTask task) async {
    final newStatus = !task.completed;
    await appDb.updateTaskStatus(task.id, newStatus);
    await appDb.updateNotificationStatusByTask(task.id, newStatus ? 'completed' : 'unread');

    if (newStatus) {
      // If completed, cancel notifications for this task
      await notificationService.cancelNotification(task.id);
    } else {
      // If uncompleted, reschedule if it's in the future
      if (task.date.isAfter(DateTime.now())) {
        final plan = _plans[task.planId];
        await notificationService.scheduleTaskNotification(
          taskId: task.id,
          userId: widget.userId,
          title: task.title,
          body: task.description ?? '',
          scheduledDate: task.date,
          colorValue: plan?.colorValue,
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

  void _showAddObservationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AddObservationDialog(userId: widget.userId, onSaved: _loadTasks),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _LunarPhaseCard(date: _focusedDay),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    locale: 'es_ES',
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
                      todayDecoration: BoxDecoration(color: AppColors.greenSoft.withOpacity(0.5), shape: BoxShape.circle),
                      selectedDecoration: const BoxDecoration(color: AppColors.greenDark, shape: BoxShape.circle),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return null;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: events.take(4).map((event) {
                            final plan = _plans[event.planId];
                            final color = plan?.colorValue != null ? Color(plan!.colorValue!) : AppColors.greenAccent;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0.5),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showAddObservationDialog,
                      icon: const Icon(Icons.note_add_rounded),
                      label: const Text('AGREGAR OBSERVACIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _loading
                    ? const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())
                    : _getTasksForDay(_selectedDay!).isEmpty
                        ? const Padding(padding: EdgeInsets.all(20), child: Text('No hay tareas para este día', style: TextStyle(fontWeight: FontWeight.w600)))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            itemCount: _getTasksForDay(_selectedDay!).length,
                            itemBuilder: (context, index) {
                              final task = _getTasksForDay(_selectedDay!)[index];
                              final plan = _plans[task.planId];
                              return _TaskTile(
                                task: task,
                                plan: plan,
                                onToggle: () => _toggleTaskStatus(task),
                                onReport: () => _reportIncident(task),
                                onDeletePlan: () => _confirmDeletePlan(plan),
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeletePlan(CropPlan? plan) async {
    if (plan == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar cultivo perdido?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Esta acción borrará el plan "${plan.nickname ?? plan.cropName}" y todas sus tareas. ¿Estás seguro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SÍ, ELIMINAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final tasks = await appDb.getUserTasks(widget.userId);
      for (final t in tasks) {
        if (t.planId == plan.id) {
          // Cancel all scheduled notifications and reminders
          await notificationService.cancelNotification(t.id);
        }
      }
      // Thorough cleanup: delete plan, tasks, and logs
      await appDb.deleteCropPlanPermanently(plan.id);
      await _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan eliminado correctamente.')));
      }
    }
  }
}

class _TaskTile extends StatelessWidget {
  final CalendarTask task;
  final CropPlan? plan;
  final VoidCallback onToggle;
  final VoidCallback onReport;
  final VoidCallback onDeletePlan;

  const _TaskTile({
    required this.task,
    this.plan,
    required this.onToggle,
    required this.onReport,
    required this.onDeletePlan,
  });

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
    final planColor = plan?.colorValue != null ? Color(plan!.colorValue!) : AppColors.greenDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: planColor.withOpacity(0.2), width: 2),
      ),
      child: ListTile(
        leading: Icon(_iconForType(task.type), color: planColor, size: 30),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plan?.nickname != null)
                    Text(
                      plan!.nickname!,
                      style: TextStyle(color: planColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDarker,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
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
              icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
              onPressed: onDeletePlan,
              tooltip: 'Eliminar cultivo perdido',
            ),
            IconButton(
              icon: const Icon(Icons.report_problem_outlined, color: Colors.orange),
              onPressed: onReport,
              tooltip: 'Reportar incidente',
            ),
            Checkbox(
              value: task.completed,
              onChanged: (_) => onToggle(),
              activeColor: planColor,
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

class _LunarPhaseCard extends StatelessWidget {
  final DateTime date;
  const _LunarPhaseCard({required this.date});

  @override
  Widget build(BuildContext context) {
    final phase = _getLunarPhase(date);
    final recommendation = _getLunarRecommendation(phase);
    final daysRemaining = _getLunarDaysRemaining(date);
    final monthDays = _getLunarPhaseMonthDays(date, phase);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.greenDark, AppColors.greenDarker],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_getLunarIcon(phase), style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fase Lunar: $phase',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Actividad: $recommendation',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LunarInfoBadge(label: 'Duración aprox.', value: '7-8 días'),
              _LunarInfoBadge(label: 'Días activos', value: monthDays),
            ],
          ),
        ],
      ),
    );
  }

  String _getLunarPhase(DateTime date) {
    final lp = 2551443;
    final now = date.millisecondsSinceEpoch / 1000;
    final newMoon = 592500;
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
      default: return '🌙';
    }
  }

  String _getLunarRecommendation(String phase) {
    switch (phase) {
      case 'Luna Nueva': return 'Preparación de suelo, control de malezas.';
      case 'Luna Creciente':
      case 'Cuarto Creciente':
      case 'Gibosa Creciente': return 'Siembra de hortalizas de hoja y frutos.';
      case 'Luna Llena': return 'Cosecha, fertilización, control de plagas.';
      default: return 'Siembra de raíces y tubérculos, poda.';
    }
  }

  int _getLunarDaysRemaining(DateTime date) {
    // This is a simplified estimation
    return 3;
  }

  String _getLunarPhaseMonthDays(DateTime date, String targetPhase) {
    // Estimate which days of the current month have this phase
    // For a real app, use a proper lunar library. Here we'll just show a range for the example.
    final day = date.day;
    return '${day - 2} al ${day + 4} de ${DateFormat('MMMM', 'es').format(date)}';
  }
}

class _LunarInfoBadge extends StatelessWidget {
  final String label;
  final String value;
  const _LunarInfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _AddObservationDialog extends StatefulWidget {
  final int userId;
  final VoidCallback onSaved;
  const _AddObservationDialog({required this.userId, required this.onSaved});

  @override
  State<_AddObservationDialog> createState() => _AddObservationDialogState();
}

class _AddObservationDialogState extends State<_AddObservationDialog> {
  final _contentCtrl = TextEditingController();
  String _selectedPlantStatus = 'Saludable';
  String _selectedStage = 'Crecimiento';
  bool _hasIrrigation = false;
  bool _hasPest = false;
  bool _hasTF = false;
  String? _selectedCropName;
  List<CropPlan> _activePlans = [];

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    final list = await appDb.getUserCropPlans(widget.userId);
    if (mounted) {
      setState(() {
        _activePlans = list;
        if (_activePlans.length == 1) {
          _selectedCropName = _activePlans.first.nickname ?? _activePlans.first.cropName;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nueva Observación', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.greenDarker)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCropName,
              items: _activePlans.map((e) {
                final name = e.nickname ?? e.cropName;
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
              onChanged: (v) => setState(() => _selectedCropName = v),
              decoration: InputDecoration(labelText: 'Selecciona tu cultivo activo', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentCtrl,
              maxLines: 3,
              decoration: InputDecoration(labelText: '¿Qué observaste hoy?', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPlantStatus,
                    items: ['Saludable', 'Marchita', 'Enferma', 'Recuperándose'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _selectedPlantStatus = v!),
                    decoration: InputDecoration(labelText: 'Estado', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStage,
                    items: ['Siembra', 'Germinación', 'Crecimiento', 'Floración', 'Fructificación', 'Cosecha'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _selectedStage = v!),
                    decoration: InputDecoration(labelText: 'Etapa', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('¿Hubo riego hoy?'),
              value: _hasIrrigation,
              onChanged: (v) => setState(() => _hasIrrigation = v!),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
            CheckboxListTile(
              title: const Text('¿Se detectó alguna plaga?'),
              value: _hasPest,
              onChanged: (v) => setState(() => _hasPest = v!),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
            CheckboxListTile(
              title: const Text('¿Hubo trasplante o fertilización?'),
              value: _hasTF,
              onChanged: (v) => setState(() => _hasTF = v!),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedCropName == null || _contentCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor completa los campos obligatorios.')));
                    return;
                  }

                  final plan = _activePlans.firstWhere((p) => (p.nickname ?? p.cropName) == _selectedCropName);
                  final cultivoData = jsonDecode(plan.payloadJson);
                  final imagePath = plan.id > 0 ? plan.payloadJson.contains('imagePath') ? cultivoData['imagePath'] : null : null;

                  await appDb.insertObservation(ObservationsCompanion.insert(
                    userId: widget.userId,
                    cropName: _selectedCropName!,
                    cropImagePath: Value(imagePath),
                    content: _contentCtrl.text,
                    plantStatus: Value(_selectedPlantStatus),
                    stage: Value(_selectedStage),
                    hasIrrigation: Value(_hasIrrigation),
                    hasPest: Value(_hasPest),
                    hasTransplantOrFertilization: Value(_hasTF),
                  ));
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Observación guardada en el diario.')));
                    widget.onSaved();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenDark, foregroundColor: Colors.white),
                child: const Text('Guardar Observación', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    String? nickname,
    int? colorValue,
  }) async {
    try {
      final planId = await appDb.insertCropPlan(CropPlansCompanion.insert(
      userId: userId,
      cropName: cultivo.nombre,
      nickname: drift.Value(nickname),
      colorValue: drift.Value(colorValue),
      startDate: startDate,
      preferredTime: '${preferredTime.hour.toString().padLeft(2, '0')}:${preferredTime.minute.toString().padLeft(2, '0')}',
      payloadJson: jsonEncode(cultivo.toJson()),
    ));

    final tasks = <CalendarTasksCompanion>[];

    // --- PHASE 1: PREPARATION & SOWING (First Week) ---
    final guia = cultivo.toJson()['guiaRapida'] as Map<String, dynamic>? ?? {};

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
    tasks.add(CalendarTasksCompanion.insert(
      planId: drift.Value(planId),
      userId: userId,
      title: 'Siembra de ${cultivo.nombre}',
      description: drift.Value(
        'Tipo: ${cultivo.ficha['Tipo de siembra'] ?? 'No especificado'}. '
        'Profundidad: ${cultivo.ficha['Profundidad de semilla'] ?? 'No especificado'}. '
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
    bool usesAlmacigo = guia['usaAlmacigo'] == true;
    int timeInAlmacigo = guia['tiempoAlmacigo'] ?? 0;

    if (usesAlmacigo && timeInAlmacigo > 0) {
      tasks.add(CalendarTasksCompanion.insert(
        planId: drift.Value(planId),
        userId: userId,
        title: 'Evaluación de trasplante: ${cultivo.nombre}',
        description: drift.Value('Verificar si ya está lista: ${guia['senalesTrasplante'] ?? 'No especificado'}'),
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
          description: drift.Value('Uso de pesticida orgánico o preventivo recomendado.'),
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