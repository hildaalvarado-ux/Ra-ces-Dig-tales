import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../data/db_instance.dart';
import '../data/app_database.dart';
import '../main.dart';
import 'calendario.dart';
import 'help_dialogs.dart';
import 'plaga_detalle.dart';

class Cultivo {
  final int? id; // null si es del catálogo
  final String nombre;
  final String imagen; // ruta del asset
  final String? imagePath; // ruta del archivo local o base64 (web)
  final String cientifico;
  final int cosechaMeses;
  final String tipo;
  final String estacion;
  final String identificacion;
  final String siembra;
  final Map<String, String> ficha;
  final List<String> plagas;
  final List<String> beneficiosos;
  final List<String> perjudiciales;

  const Cultivo({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.cientifico,
    required this.cosechaMeses,
    required this.tipo,
    required this.estacion,
    required this.identificacion,
    required this.siembra,
    required this.ficha,
    required this.plagas,
    this.beneficiosos = const [],
    this.perjudiciales = const [],
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        'cientifico': cientifico,
        'cosechaMeses': cosechaMeses,
        'tipo': tipo,
        'estacion': estacion,
        'identificacion': identificacion,
        'siembra': siembra,
        'ficha': ficha,
        'plagas': plagas,
        'beneficiosos': beneficiosos,
        'perjudiciales': perjudiciales,
      };

  static Cultivo fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final plagas = (j['plagas'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final ben = (j['beneficiosos'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final per = (j['perjudiciales'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    return Cultivo(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      cientifico: (j['cientifico'] ?? '').toString(),
      cosechaMeses: (j['cosechaMeses'] ?? 0) is int
          ? (j['cosechaMeses'] as int)
          : int.tryParse('${j['cosechaMeses']}') ?? 0,
      tipo: (j['tipo'] ?? '').toString(),
      estacion: (j['estacion'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      siembra: (j['siembra'] ?? '').toString(),
      ficha: ficha,
      plagas: plagas,
      beneficiosos: ben,
      perjudiciales: per,
    );
  }
}

class CultivoDetallePage extends StatelessWidget {
  final Cultivo cultivo;
  const CultivoDetallePage({super.key, required this.cultivo});

  Future<void> _shareCrop(BuildContext context) async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      // JSON del cultivo
      final jsonStr = jsonEncode(cultivo.toJson());
      archive.addFile(ArchiveFile('cultivo.json', jsonStr.length, utf8.encode(jsonStr)));

      // Imagen si existe
      if (cultivo.imagePath != null && cultivo.imagePath!.isNotEmpty) {
        if (cultivo.imagePath!.startsWith('data:image')) {
          final parts = cultivo.imagePath!.split(',');
          final bytes = base64Decode(parts.last);
          final ext = parts.first.split('/').last.split(';').first;
          archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
        } else {
          final file = File(cultivo.imagePath!);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            final ext = file.path.split('.').last;
            archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
          }
        }
      }

      final zipData = encoder.encode(archive);
      if (zipData == null) return;

      if (kIsWeb) {
        // En Web, descargamos el archivo
        final blob = XFile.fromData(Uint8List.fromList(zipData),
            name: '${cultivo.nombre}.rdc', mimeType: 'application/zip');
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${cultivo.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);

        await Share.shareXFiles([XFile(zipFile.path)], text: 'Mira mi cultivo: ${cultivo.nombre}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir: $e')),
      );
    }
  }

  Widget _buildImage() {
    if (cultivo.imagePath != null && cultivo.imagePath!.isNotEmpty) {
      if (cultivo.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(cultivo.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            cultivo.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(cultivo.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      }
    }

    if (cultivo.imagen.isNotEmpty) {
      return Image.asset(
        cultivo.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.local_florist_rounded),
      );
    }

    return const Icon(
      Icons.local_florist_rounded,
      color: AppColors.greenDarker,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return FutureBuilder<int?>(
      future: appDb.getActiveUserId(),
      builder: (context, snapshot) {
        final userId = snapshot.data;
        if (userId == null) return const SizedBox.shrink();

        return FutureBuilder<List<CropPlan>>(
          future: appDb.getUserCropPlans(userId),
          builder: (context, planSnapshot) {
            final activePlans = planSnapshot.data ?? [];
            final hasActivePlan = activePlans.any((p) => p.cropName == cultivo.nombre);

            return Column(
              children: [
                if (!hasActivePlan)
                  _buildStartPlanButton(context)
                else
                  _buildDeletePlanButton(context, activePlans.firstWhere((p) => p.cropName == cultivo.nombre)),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStartPlanButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.greenDark.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showQuickGuide(context),
        icon: const Icon(Icons.calendar_today_rounded, color: Colors.white),
        label: const Text(
          'EMPEZAR PLAN DE CULTIVO',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildDeletePlanButton(BuildContext context, CropPlan plan) {
    return Container(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () => _showDeleteConfirmation(context, plan),
        icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
        label: const Text(
          'ELIMINAR CULTIVO PERDIDO',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, CropPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar cultivo perdido?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Esta acción borrará el plan y todas las tareas del calendario. ¿Estás seguro de que la planta no es recuperable?'),
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
      await appDb.deactivateCropPlan(plan.id);
      await appDb.deleteTasksByPlan(plan.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan eliminado correctamente.')));
        Navigator.pop(context); // Refresh by going back
      }
    }
  }

  Future<void> _showQuickGuide(BuildContext context) async {
    final guia = cultivo.toJson()['guiaRapida'] as Map<String, dynamic>? ?? {};

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  const Text('Guía Rápida de Siembra', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.greenDarker)),
                  const SizedBox(height: 16),
                  _buildGuideItem(Icons.waves, 'Preparación de la tierra', guia['preparacionTierra'] ?? 'No especificado'),
                  _buildGuideItem(Icons.grass, 'Cómo sembrar correctamente', guia['comoSembrar'] ?? 'No especificado'),
                  _buildGuideItem(Icons.water_drop, 'Cuidados durante germinación', guia['cuidadosGerminacion'] ?? 'No especificado'),
                  if (guia['usaAlmacigo'] == true) ...[
                    _buildGuideItem(Icons.home, 'Tiempo en almácigo', '${guia['tiempoAlmacigo']} días'),
                    _buildGuideItem(Icons.label_important, 'Señales para trasplante', guia['senalesTrasplante'] ?? 'No especificado'),
                  ],
                  _buildGuideItem(Icons.straighten, 'Distancia de trasplante / siembra', guia['distanciaTrasplante'] ?? 'No especificado'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showStartPlanDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenDark,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('ENTENDIDO, PROGRAMAR CULTIVO', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGuideItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.greenDark, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showStartPlanDialog(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Programar Cultivo', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Elige cuándo quieres empezar y a qué hora quieres recibir recordatorios:'),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text('Fecha de inicio'),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                  ),
                  ListTile(
                    title: const Text('Hora de tareas'),
                    subtitle: Text(selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) setState(() => selectedTime = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenDark, foregroundColor: Colors.white),
                  child: const Text('GENERAR PLAN'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final userId = await appDb.getActiveUserId();
      if (userId == null) return;

      await CropPlanGenerator.generate(
        userId: userId,
        cultivo: cultivo,
        startDate: selectedDate,
        preferredTime: selectedTime,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plan para ${cultivo.nombre} generado con éxito.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CalendarioPage(userId: userId)),
        );
      }
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
          title: Text(cultivo.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'Compartir',
              onPressed: () => _shareCrop(context),
              icon: const Icon(Icons.share_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            children: [
              _buildActionButtons(context),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildImage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/id.png',
                title: 'Identificación',
                onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Descripción breve para reconocer el cultivo.'),
                child: Text(cultivo.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/siembra.png',
                title: 'Siembra',
                onHelp: () => HelpDialogs.show(context, title: 'Siembra', text: 'Consejos básicos para sembrar este cultivo.'),
                child: Text(cultivo.siembra, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha rápida',
                onHelp: () => HelpDialogs.show(context, title: 'Ficha rápida', text: 'Datos clave como distancia, profundidad, clima y riego.'),
                child: Column(
                  children: [
                    ...cultivo.ficha.entries
                      .map((e) => _InfoRow(
                            label: e.key,
                            value: e.key == 'Temporada de siembra' || e.key == 'Temporada de cosecha'
                                ? AgriculturalLogic.mapSeasonToElSalvador(e.value)
                                : e.value,
                            onHelp: () => HelpDialogs.show(context, title: e.key, text: HelpDialogs.textForField(e.key)),
                          )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (cultivo.plagas.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/id.png', // Reusing ID for now
                  title: 'Plagas',
                  onHelp: () => HelpDialogs.show(context, title: 'Plagas', text: 'Plagas comunes que pueden afectar este cultivo.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cultivo.plagas.map((p) => _RelatedChip(name: p, type: 'plaga')).toList(),
                  ),
                ),
              if (cultivo.beneficiosos.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailCard(
                  icon: 'assets/iconos/verano.png',
                  title: 'Cultivos Beneficiosos',
                  onHelp: () => HelpDialogs.show(context, title: 'Beneficiosos', text: 'Cultivos que crecen mejor junto a este.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cultivo.beneficiosos.map((c) => _RelatedChip(name: c, type: 'cultivo')).toList(),
                  ),
                ),
              ],
              if (cultivo.perjudiciales.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailCard(
                  icon: 'assets/iconos/invierno.png',
                  title: 'Cultivos Perjudiciales',
                  onHelp: () => HelpDialogs.show(context, title: 'Perjudiciales', text: 'Cultivos que deben evitarse cerca de este.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cultivo.perjudiciales.map((c) => _RelatedChip(name: c, type: 'cultivo')).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onHelp;
  final Widget child;

  const _DetailCard({required this.icon, required this.title, required this.onHelp, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.info_outline)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 16)),
              const Spacer(),
              IconButton(onPressed: onHelp, icon: const Icon(Icons.help_outline_rounded), color: AppColors.greenDarker),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onHelp;
  const _InfoRow({required this.label, required this.value, required this.onHelp});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Expanded(child: Text('$label\n$value', style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w700, height: 1.25))),
          IconButton(onPressed: onHelp, icon: const Icon(Icons.help_outline_rounded), color: AppColors.greenDarker),
        ],
      ),
    );
  }
}

class _RelatedChip extends StatelessWidget {
  final String name;
  final String type; // 'cultivo' or 'plaga'

  const _RelatedChip({required this.name, required this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final String assetPath = type == 'cultivo' ? 'assets/data/cultivos.json' : 'assets/data/plagas.json';
          final raw = await rootBundle.loadString(assetPath);
          final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
          final decoded = jsonDecode(cleanJson) as List;

          if (type == 'cultivo') {
            final catalog = decoded.map((e) => Cultivo.fromJson(Map<String, dynamic>.from(e))).toList();
            final item = catalog.firstWhere((i) => i.nombre.toLowerCase() == name.toLowerCase());
            if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => CultivoDetallePage(cultivo: item)));
          } else {
            final catalog = decoded.map((e) => Plaga.fromJson(Map<String, dynamic>.from(e))).toList();
            final item = catalog.firstWhere((i) => i.nombre.toLowerCase() == name.toLowerCase());
            if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => PlagaDetallePage(plaga: item)));
          }
        } catch (e) {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sin detalle para: $name')));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greenDark.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type == 'cultivo' ? Icons.local_florist_rounded : Icons.bug_report_rounded, size: 16, color: AppColors.greenDarker),
            const SizedBox(width: 4),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.greenDarker)),
          ],
        ),
      ),
    );
  }
}