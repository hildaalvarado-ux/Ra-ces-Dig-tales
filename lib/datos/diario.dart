import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/db_instance.dart';
import '../data/app_database.dart';
import '../main.dart';

class DiarioPage extends StatefulWidget {
  final int userId;
  const DiarioPage({super.key, required this.userId});

  @override
  State<DiarioPage> createState() => _DiarioPageState();
}

class _DiarioPageState extends State<DiarioPage> {
  bool _loading = true;
  Map<String, List<Observation>> _groupedObservations = {};
  List<String> _sortedGroupKeys = [];
  Map<int, CropPlan> _plans = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final obsList = await appDb.getUserObservations(widget.userId);
    final plansList = await appDb.getAllUserCropPlans(widget.userId);

    // Agrupar observaciones
    final Map<String, List<Observation>> groups = {};
    for (var obs in obsList) {
      final key = obs.planId?.toString() ?? obs.cropName;
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(obs);
    }

    // Ordenar cada grupo por fecha ascendente para el historial
    for (var key in groups.keys) {
      groups[key]!.sort((a, b) => a.date.compareTo(b.date));
    }

    // Ordenar las llaves de los grupos por la fecha de la última observación (descendente)
    final keys = groups.keys.toList();
    keys.sort((a, b) {
      final latestA = groups[a]!.last.date;
      final latestB = groups[b]!.last.date;
      return latestB.compareTo(latestA);
    });

    setState(() {
      _groupedObservations = groups;
      _sortedGroupKeys = keys;
      _plans = {for (var p in plansList) p.id: p};
      _loading = false;
    });
  }

  Future<void> _deleteObservation(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar observación'),
        content: const Text('¿Estás seguro de que quieres eliminar esta nota del diario?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (ok == true) {
      await (appDb.delete(appDb.observations)..where((t) => t.id.equals(id))).go();
      _loadData();
    }
  }

  void _showHistoryModal(String cropName, List<Observation> history) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.history_rounded, color: AppColors.greenDark, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Historial: $cropName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.greenDarker,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final obs = history[index];
                      final plan = obs.planId != null ? _plans[obs.planId] : null;
                      return _HistoryObservationTile(
                        obs: obs,
                        plan: plan,
                        onDelete: () async {
                          await _deleteObservation(obs.id);
                          // Since _deleteObservation calls _loadData, we need to close modal
                          // or refresh its content. To be simple, we close it and let the user re-open if needed.
                          if (mounted) Navigator.pop(context);
                        },
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
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Diario de Observaciones', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _sortedGroupKeys.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay registros en el diario aún.\nAgrega observaciones desde el calendario.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: _sortedGroupKeys.length,
                      itemBuilder: (context, index) {
                        final key = _sortedGroupKeys[index];
                        final obsGroup = _groupedObservations[key]!;
                        final latestObs = obsGroup.last;
                        final plan = latestObs.planId != null ? _plans[latestObs.planId] : null;

                        return _GroupedObservationCard(
                          observations: obsGroup,
                          plan: plan,
                          onTap: () => _showHistoryModal(latestObs.cropName, obsGroup),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

class _GroupedObservationCard extends StatelessWidget {
  final List<Observation> observations;
  final CropPlan? plan;
  final VoidCallback onTap;

  const _GroupedObservationCard({
    required this.observations,
    this.plan,
    required this.onTap,
  });

  Observation get latest => observations.last;

  Widget _buildImage() {
    String? imagePath = latest.cropImagePath;
    if (imagePath == null || imagePath.isEmpty) {
      if (plan != null) {
        try {
          final data = jsonDecode(plan!.payloadJson);
          imagePath = data['imagePath'];
        } catch (_) {}
      }
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('data:image')) {
        return Image.memory(
          base64Decode(imagePath.split(',').last),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        );
      } else if (imagePath.startsWith('assets/')) {
        return Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover);
      } else {
        if (kIsWeb) {
          return Image.network(imagePath, width: 60, height: 60, fit: BoxFit.cover);
        } else {
          return Image.file(File(imagePath), width: 60, height: 60, fit: BoxFit.cover);
        }
      }
    }
    return const Icon(Icons.local_florist_rounded, color: AppColors.greenDark, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    final obs = latest;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: AppColors.greenSoft.withOpacity(0.2),
                    child: _buildImage(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(obs.cropName, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker, fontSize: 17)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yy, hh:mm a', 'es').format(obs.date),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (plan != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.greenDark.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Semana ${obs.date.difference(plan!.startDate).inDays ~/ 7 + 1}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (obs.plantStatus != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(obs.plantStatus!).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _getStatusColor(obs.plantStatus!).withOpacity(0.5)),
                    ),
                    child: Text(
                      obs.plantStatus!,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _getStatusColor(obs.plantStatus!)),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            Text(
              obs.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.3, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${observations.length} ${observations.length == 1 ? "observación" : "observaciones"}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.greenSoft),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Saludable': return Colors.green;
      case 'Marchita': return Colors.brown;
      case 'Enferma': return Colors.red;
      case 'Recuperándose': return Colors.orange;
      default: return Colors.grey;
    }
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const _Tag({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 4)],
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _HistoryObservationTile extends StatelessWidget {
  final Observation obs;
  final CropPlan? plan;
  final VoidCallback onDelete;

  const _HistoryObservationTile({
    required this.obs,
    this.plan,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd MMMM, yyyy', 'es').format(obs.date),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text(
                    DateFormat('hh:mm a', 'es').format(obs.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Spacer(),
              if (plan != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.greenDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Semana ${obs.date.difference(plan!.startDate).inDays ~/ 7 + 1}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                  ),
                ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (obs.stage != null || obs.plantStatus != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                spacing: 8,
                children: [
                  if (obs.stage != null)
                    _Tag(label: 'Etapa: ${obs.stage}', color: Colors.blueGrey),
                  if (obs.plantStatus != null)
                    _Tag(
                      label: obs.plantStatus!,
                      color: _getStatusColor(obs.plantStatus!),
                    ),
                ],
              ),
            ),
          Text(
            obs.content,
            style: const TextStyle(height: 1.4, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (obs.hasIrrigation) _IndicatorIcon(icon: Icons.water_drop, color: Colors.blue, label: 'Riego'),
              if (obs.hasPest) _IndicatorIcon(icon: Icons.bug_report, color: Colors.red, label: 'Insecto'),
              if (obs.hasFertilization) _IndicatorIcon(icon: Icons.science_rounded, color: Colors.orange, label: 'Fert.'),
              if (obs.hasTransplant) _IndicatorIcon(icon: Icons.import_export_rounded, color: Colors.teal, label: 'Trasp.'),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Saludable': return Colors.green;
      case 'Marchita': return Colors.brown;
      case 'Enferma': return Colors.red;
      case 'Recuperándose': return Colors.orange;
      default: return Colors.grey;
    }
  }
}

class _IndicatorIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _IndicatorIcon({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
