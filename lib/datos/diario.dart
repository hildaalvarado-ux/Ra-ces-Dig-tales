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

  @override
  void initState() {
    super.initState();
    _loadObservations();
  }

  Future<void> _loadObservations() async {
    setState(() => _loading = true);
    final list = await appDb.getUserObservations(widget.userId);
    setState(() {
      _observations = list;
      _loading = false;
    });
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
                        return _ObservationCard(obs: obs);
                      },
                    ),
        ),
      ),
    );
  }
}

class _ObservationCard extends StatelessWidget {
  final Observation obs;
  const _ObservationCard({required this.obs});

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
                    Text(
                      DateFormat('dd MMMM yyyy, hh:mm a', 'es').format(obs.date),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
              if (obs.hasPest) _Tag(label: 'Plaga detectada', color: Colors.red, icon: Icons.bug_report),
              if (obs.hasTransplantOrFertilization) _Tag(label: 'Trasplante/Fert.', color: Colors.orange, icon: Icons.auto_awesome),
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
