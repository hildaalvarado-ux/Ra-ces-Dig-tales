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
  List<Observation> _observations = [];
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

    // Sort chronological ascending
    obsList.sort((a, b) => a.date.compareTo(b.date));

    setState(() {
      _observations = obsList;
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
              : _observations.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay registros en el diario aún.\nAgrega observaciones desde el calendario.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: _observations.length,
                      itemBuilder: (context, index) {
                        final obs = _observations[index];
                        final plan = obs.planId != null ? _plans[obs.planId] : null;
                        return _ObservationCard(
                          obs: obs,
                          plan: plan,
                          onDelete: () => _deleteObservation(obs.id),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

class _ObservationCard extends StatelessWidget {
  final Observation obs;
  final CropPlan? plan;
  final VoidCallback onDelete;
  const _ObservationCard({required this.obs, this.plan, required this.onDelete});

  Widget _buildImage() {
    if (obs.cropImagePath != null && obs.cropImagePath!.isNotEmpty) {
      if (obs.cropImagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(obs.cropImagePath!.split(',').last),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      } else {
        if (kIsWeb) {
          return Image.network(obs.cropImagePath!, width: 50, height: 50, fit: BoxFit.cover);
        } else {
          return Image.file(File(obs.cropImagePath!), width: 50, height: 50, fit: BoxFit.cover);
        }
      }
    }
    return const Icon(Icons.local_florist_rounded, color: AppColors.greenDark);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 50,
                  height: 50,
                  color: AppColors.greenSoft.withOpacity(0.2),
                  child: _buildImage(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(obs.cropName, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker, fontSize: 16)),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yy, hh:mm a', 'es').format(obs.date),
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                        ),
                        if (plan != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.greenDark.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Semana ${obs.date.difference(plan!.startDate).inDays ~/ 7 + 1}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: onDelete,
              ),
              if (obs.plantStatus != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(obs.plantStatus!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getStatusColor(obs.plantStatus!).withOpacity(0.5)),
                  ),
                  child: Text(
                    obs.plantStatus!,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getStatusColor(obs.plantStatus!)),
                  ),
                ),
            ],
          ),
          const Divider(height: 20),
          Text(obs.content, style: const TextStyle(height: 1.3, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              if (obs.stage != null) _Tag(label: 'Etapa: ${obs.stage}', color: Colors.blueGrey),
              if (obs.hasIrrigation) _Tag(label: 'Riego', color: Colors.blue, icon: Icons.water_drop),
              if (obs.hasPest) _Tag(label: 'Plaga', color: Colors.red, icon: Icons.bug_report),
              if (obs.hasFertilization) _Tag(label: 'Fertilización', color: Colors.orange, icon: Icons.science_rounded),
              if (obs.hasTransplant) _Tag(label: 'Trasplante', color: Colors.teal, icon: Icons.import_export_rounded),
              // Support for legacy data
              if (obs.hasTransplantOrFertilization && !obs.hasFertilization && !obs.hasTransplant)
                _Tag(label: 'Trasplante/Fert.', color: Colors.orange, icon: Icons.auto_awesome),
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
