import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../data/app_database.dart';
import '../data/db_instance.dart';
import '../data/soil_models.dart';
import '../main.dart';
import 'cultivo_detalle.dart';

class PreparacionSueloPage extends StatefulWidget {
  final int userId;
  const PreparacionSueloPage({super.key, required this.userId});

  @override
  State<PreparacionSueloPage> createState() => _PreparacionSueloPageState();
}

class _PreparacionSueloPageState extends State<PreparacionSueloPage> {
  List<SoilPreparation> _preparations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final list = await appDb.getUserSoilPreparations(widget.userId);
    setState(() {
      _preparations = list;
      _loading = false;
    });
  }

  void _createNewPreparation() async {
    String? selectedCrop;
    final crops = await appDb.getUserCultivos(widget.userId);
    final catalogRaw = await DefaultAssetBundle.of(context).loadString('assets/data/cultivos.json');
    final catalog = (jsonDecode(catalogRaw) as List).map((e) => Cultivo.fromJson(e)).toList();

    if (!mounted) return;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Preparación', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('¿Para qué cultivo es esta preparación? (Opcional)'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Cultivo'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('General / Varios')),
                    ...catalog.map((e) => DropdownMenuItem(value: e.nombre, child: Text(e.nombre))),
                    ...crops.map((e) => DropdownMenuItem(value: e.nombre, child: Text('${e.nombre} (Mío)'))),
                  ],
                  onChanged: (v) => selectedCrop = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedCrop ?? 'General'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenDark),
              child: const Text('CREAR', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (result != null) {
      final tasks = SoilCatalog.procesos.map((p) => TareaPreparacion(tipo: p['tipo'])).toList();

      await appDb.insertSoilPreparation(SoilPreparationsCompanion.insert(
        userId: widget.userId,
        cropName: drift.Value(result == 'General' ? null : result),
        payloadJson: jsonEncode(tasks.map((e) => e.toJson()).toList()),
      ));
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.greenDark,
            foregroundColor: Colors.white,
            title: const Text('Preparación del Suelo', style: TextStyle(fontWeight: FontWeight.w900)),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.menu_book), text: 'Aprender'),
                Tab(icon: Icon(Icons.handyman), text: 'Mi preparación'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildAprenderTab(),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _preparations.isEmpty
                      ? _buildEmptyState()
                      : _buildMiPreparacionTab(),
            ],
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton.extended(
              onPressed: _createNewPreparation,
              backgroundColor: AppColors.greenDark,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('INICIAR PREPARACIÓN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAprenderTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: SoilCatalog.procesos.length,
      itemBuilder: (context, index) {
        final proceso = SoilCatalog.procesos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.greenDark.withOpacity(0.1),
              child: Text('${index + 1}', style: const TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.bold)),
            ),
            title: Text(proceso['tipo'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDarker)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('¿Por qué es importante?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                    const SizedBox(height: 4),
                    Text(proceso['explicacion'] ?? 'No hay explicación disponible.'),
                    const SizedBox(height: 12),
                    const Text('Recomendaciones:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                    const SizedBox(height: 4),
                    Text(proceso['recomendaciones'] ?? 'No hay recomendaciones.'),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text('Métodos disponibles:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...(proceso['metodos'] as List).map((m) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m['nombre'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('${m['duracionDias']} días - ${m['descripcion']}', style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.info_outline, size: 20),
                      onTap: () => _showMetodoTeorico(m),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMetodoTeorico(Map<String, dynamic> m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Text(m['nombre'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
            const SizedBox(height: 8),
            Text('${m['duracionDias']} días de duración', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            Text(m['descripcion'], style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 24),
            const Text('Pasos a seguir:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...List<String>.from(m['pasos']).asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 12, backgroundColor: AppColors.greenDark, child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: const TextStyle(fontSize: 15))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMiPreparacionTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _preparations.length,
      itemBuilder: (context, index) {
        final prep = _preparations[index];
        return _PreparationCard(
          preparation: prep,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SoilPreparationDetailPage(preparation: prep),
            ),
          ).then((_) => _loadData()),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers_clear_outlined, size: 80, color: AppColors.greenDark.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'Aún no has iniciado la preparación del suelo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => DefaultTabController.of(context).animateTo(0),
              icon: const Icon(Icons.menu_book),
              label: const Text('VER CÓMO PREPARAR EL SUELO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.greenDark,
                side: const BorderSide(color: AppColors.greenDark),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _createNewPreparation,
              icon: const Icon(Icons.play_arrow),
              label: const Text('INICIAR PREPARACIÓN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenDark,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreparationCard extends StatelessWidget {
  final SoilPreparation preparation;
  final VoidCallback onTap;

  const _PreparationCard({required this.preparation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tasks = (jsonDecode(preparation.payloadJson) as List).map((e) => TareaPreparacion.fromJson(e)).toList();
    final completedCount = tasks.where((t) => t.estado == 'completado').length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      preparation.cropName ?? 'Preparación General',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDarker),
                    ),
                  ),
                  _StatusChip(status: preparation.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    preparation.fechaListaSuelo != null
                        ? 'Listo el: ${DateFormat('dd/MM/yyyy').format(preparation.fechaListaSuelo!)}'
                        : 'Fecha estimada: Pendiente',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.greenDark,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              if (preparation.riesgo) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    const Text('Iniciado bajo riesgo', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isCompleted ? 'COMPLETADO' : 'EN PROCESO',
        style: TextStyle(
          color: isCompleted ? Colors.green.shade800 : Colors.blue.shade800,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SoilPreparationDetailPage extends StatefulWidget {
  final SoilPreparation preparation;
  const SoilPreparationDetailPage({super.key, required this.preparation});

  @override
  State<SoilPreparationDetailPage> createState() => _SoilPreparationDetailPageState();
}

class _SoilPreparationDetailPageState extends State<SoilPreparationDetailPage> {
  late List<TareaPreparacion> _tasks;
  late bool _riesgo;
  late String _status;

  @override
  void initState() {
    super.initState();
    _riesgo = widget.preparation.riesgo;
    _status = widget.preparation.status;
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = (jsonDecode(widget.preparation.payloadJson) as List).map((e) => TareaPreparacion.fromJson(e)).toList();
    _checkAndUpdateStatuses();
  }

  void _checkAndUpdateStatuses() {
    bool changed = false;
    final now = DateTime.now();
    for (int i = 0; i < _tasks.length; i++) {
      final t = _tasks[i];
      if (t.estado == 'en_proceso' && t.fechaFin != null) {
        if (now.isAfter(t.fechaFin!) || now.isAtSameMomentAs(t.fechaFin!)) {
          _tasks[i] = t.copyWith(estado: 'completado');
          changed = true;
        }
      }
    }

    if (_tasks.every((t) => t.estado == 'completado') && _status != 'completed') {
      _status = 'completed';
      changed = true;
    }

    if (changed) {
      _save();
    }
  }

  Future<void> _save() async {
    DateTime? maxFechaFin;
    for (var t in _tasks) {
      if (t.fechaFin != null) {
        if (maxFechaFin == null || t.fechaFin!.isAfter(maxFechaFin)) {
          maxFechaFin = t.fechaFin;
        }
      }
    }

    final completed = _tasks.every((t) => t.estado == 'completado');

    await appDb.updateSoilPreparation(SoilPreparationsCompanion(
      id: drift.Value(widget.preparation.id),
      fechaListaSuelo: drift.Value(maxFechaFin),
      completado: drift.Value(completed),
      riesgo: drift.Value(_riesgo),
      status: drift.Value(_status),
      payloadJson: drift.Value(jsonEncode(_tasks.map((e) => e.toJson()).toList())),
    ));
    if (mounted) setState(() {});
  }

  void _selectMethod(int index) async {
    final task = _tasks[index];
    final proceso = SoilCatalog.procesos.firstWhere((p) => p['tipo'] == task.tipo);
    final metodos = (proceso['metodos'] as List).map((m) => MetodoPreparacion(
      nombre: m['nombre'],
      duracionDias: m['duracionDias'],
      descripcion: m['descripcion'],
      pasos: List<String>.from(m['pasos']),
    )).toList();

    final selected = await showModalBottomSheet<MetodoPreparacion>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Seleccionar método: ${task.tipo}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: metodos.length,
                    itemBuilder: (context, i) {
                      final m = metodos[i];
                      return ListTile(
                        title: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${m.duracionDias} días - ${m.descripcion}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pop(context, m),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      final now = DateTime.now();
      setState(() {
        _tasks[index] = task.copyWith(
          metodoSeleccionado: selected.nombre,
          duracionDias: selected.duracionDias,
          fechaInicio: now,
          fechaFin: now.add(Duration(days: selected.duracionDias)),
          estado: 'en_proceso',
        );
      });
      _save();
    }
  }

  void _showInfo(int index) {
    final task = _tasks[index];
    if (task.metodoSeleccionado == null) return;

    final proceso = SoilCatalog.procesos.firstWhere((p) => p['tipo'] == task.tipo);
    final metodoData = (proceso['metodos'] as List).firstWhere((m) => m['nombre'] == task.metodoSeleccionado);
    final metodo = MetodoPreparacion(
      nombre: metodoData['nombre'],
      duracionDias: metodoData['duracionDias'],
      descripcion: metodoData['descripcion'],
      pasos: List<String>.from(metodoData['pasos']),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Text(metodo.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                const SizedBox(height: 8),
                Text('${metodo.duracionDias} días de duración', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 16),
                Text(metodo.descripcion, style: const TextStyle(fontSize: 16, height: 1.4)),
                const SizedBox(height: 24),
                const Text('Pasos a seguir:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...metodo.pasos.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 12, backgroundColor: AppColors.greenDark, child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                      const SizedBox(width: 12),
                      Expanded(child: Text(e.value, style: const TextStyle(fontSize: 15))),
                    ],
                  ),
                )),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.estado == 'completado').length;
    final progress = _tasks.isEmpty ? 0.0 : completedCount / _tasks.length;
    DateTime? maxDate;
    for (var t in _tasks) if (t.fechaFin != null && (maxDate == null || t.fechaFin!.isAfter(maxDate))) maxDate = t.fechaFin;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(widget.preparation.cropName ?? 'Preparación General'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar'),
                    content: const Text('¿Deseas eliminar este proceso de preparación?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('NO')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('SÍ', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (ok == true) {
                  await appDb.deleteSoilPreparation(widget.preparation.id);
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progreso General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: AppColors.greenDark, minHeight: 10),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.event_available, color: AppColors.greenSoft, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        maxDate != null
                            ? 'Suelo listo el: ${DateFormat('dd/MM/yyyy').format(maxDate)}'
                            : 'Selecciona métodos para estimar fecha',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final t = _tasks[index];
                  final disinfectionCompleted = _tasks.any((element) => element.tipo == 'Desinfección del suelo' && element.estado == 'completado');

                  return _TaskCard(
                    task: t,
                    index: index,
                    disinfectionCompleted: disinfectionCompleted,
                    onSelect: () => _selectMethod(index),
                    onInfo: () => _showInfo(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TareaPreparacion task;
  final int index;
  final bool disinfectionCompleted;
  final VoidCallback onSelect;
  final VoidCallback onInfo;

  const _TaskCard({
    required this.task,
    required this.index,
    required this.disinfectionCompleted,
    required this.onSelect,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (task.estado) {
      case 'completado':
        statusColor = Colors.green;
        statusText = 'Completado';
        break;
      case 'en_proceso':
        statusColor = Colors.blue;
        statusText = 'En proceso';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Pendiente';
    }

    final isSowing = task.tipo.toLowerCase().contains('siembra');
    final isAlmacigo = task.tipo.toLowerCase().contains('almácigo');
    final needsDisinfection = (isSowing || isAlmacigo) && !disinfectionCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.greenDark.withOpacity(0.1),
                  child: Text('${index + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(task.tipo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (needsDisinfection && task.estado != 'completado')
               Container(
                 padding: const EdgeInsets.all(8),
                 margin: const EdgeInsets.only(bottom: 8),
                 decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                 child: Row(
                   children: [
                     const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                     const SizedBox(width: 8),
                     Expanded(child: Text('IMPORTANTE: No se recomienda realizar esta tarea sin completar primero la desinfección.', style: TextStyle(fontSize: 11, color: Colors.orange.shade900, fontWeight: FontWeight.bold))),
                   ],
                 ),
               ),
            if (task.metodoSeleccionado != null) ...[
              Text('Método: ${task.metodoSeleccionado}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Duración: ${task.duracionDias} días', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              if (task.fechaFin != null)
                Text('Finaliza: ${DateFormat('dd/MM/yyyy').format(task.fechaFin!)}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ] else
              const Text('Sin método seleccionado', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSelect,
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.greenDark)),
                    child: Text(task.metodoSeleccionado == null ? 'SELECCIONAR MÉTODO' : 'CAMBIAR MÉTODO'),
                  ),
                ),
                const SizedBox(width: 8),
                if (task.metodoSeleccionado != null)
                  IconButton(
                    onPressed: onInfo,
                    icon: const Icon(Icons.info_outline, color: AppColors.greenDark),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
