import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../main.dart';
import 'help_dialogs.dart';

class Fertilizante {
  final int? id;
  final String nombre;
  final String imagen;
  final String? imagePath;
  final String tipo;
  final String identificacion;
  final String uso;
  final Map<String, String> ficha;
  final String ingredientes;
  final String elaboracion;
  final String precauciones;
  final bool esCasero;
  final String dificultad;
  final String faseAplicacion;

  const Fertilizante({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.tipo,
    required this.identificacion,
    required this.uso,
    required this.ficha,
    this.ingredientes = '',
    this.elaboracion = '',
    this.precauciones = '',
    this.esCasero = false,
    this.dificultad = '',
    this.faseAplicacion = '',
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        'tipo': tipo,
        'identificacion': identificacion,
        'uso': uso,
        'ficha': ficha,
        'ingredientes': ingredientes,
        'elaboracion': elaboracion,
        'precauciones': precauciones,
        'esCasero': esCasero,
        'dificultad': dificultad,
        'faseAplicacion': faseAplicacion,
      };

  static Fertilizante fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    return Fertilizante(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      tipo: (j['tipo'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      uso: (j['uso'] ?? '').toString(),
      ficha: ficha,
      ingredientes: (j['ingredientes'] ?? '').toString(),
      elaboracion: (j['elaboracion'] ?? '').toString(),
      precauciones: (j['precauciones'] ?? '').toString(),
      esCasero: j['esCasero'] ?? false,
      dificultad: (j['dificultad'] ?? '').toString(),
      faseAplicacion: (j['faseAplicacion'] ?? '').toString(),
    );
  }
}

class FertilizanteDetallePage extends StatelessWidget {
  final Fertilizante fertilizante;
  const FertilizanteDetallePage({super.key, required this.fertilizante});

  Future<void> _share(BuildContext context) async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      final jsonStr = jsonEncode(fertilizante.toJson());
      archive.addFile(ArchiveFile('fertilizante.json', jsonStr.length, utf8.encode(jsonStr)));

      if (fertilizante.imagePath != null && fertilizante.imagePath!.isNotEmpty) {
        if (fertilizante.imagePath!.startsWith('data:image')) {
          final parts = fertilizante.imagePath!.split(',');
          final bytes = base64Decode(parts.last);
          final ext = parts.first.split('/').last.split(';').first;
          archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
        } else {
          final file = File(fertilizante.imagePath!);
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
        final blob = XFile.fromData(Uint8List.fromList(zipData),
            name: '${fertilizante.nombre}.rdc', mimeType: 'application/zip');
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${fertilizante.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);
        await Share.shareXFiles([XFile(zipFile.path)], text: 'Mira este fertilizante: ${fertilizante.nombre}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  Widget _buildImage() {
    if (fertilizante.imagePath != null && fertilizante.imagePath!.isNotEmpty) {
      if (fertilizante.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(fertilizante.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            fertilizante.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(fertilizante.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      }
    }
    if (fertilizante.imagen.isNotEmpty) {
      return Image.asset(
        fertilizante.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.science_rounded),
      );
    }
    return const Icon(Icons.science_rounded, color: AppColors.greenDarker, size: 64);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(fertilizante.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'Compartir',
              onPressed: () => _share(context),
              icon: const Icon(Icons.share_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            children: [
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
                onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Descripción del fertilizante.'),
                child: Text(fertilizante.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/siembra.png',
                title: 'Modo de Uso',
                onHelp: () => HelpDialogs.show(context, title: 'Modo de Uso', text: 'Cómo aplicar este fertilizante y en qué fase.'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fertilizante.uso, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                    if (fertilizante.faseAplicacion.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text('Fase de aplicación:', style: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 13)),
                      Text(fertilizante.faseAplicacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.8), fontWeight: FontWeight.w700)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (fertilizante.esCasero) ...[
                _DetailCard(
                  icon: 'assets/iconos/id.png',
                  title: 'Elaboración Casera',
                  onHelp: () => HelpDialogs.show(context, title: 'Elaboración', text: 'Instrucciones para crear este fertilizante en casa.'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (fertilizante.dificultad.isNotEmpty)
                        _InfoRow(label: 'Dificultad', value: fertilizante.dificultad),
                      if (fertilizante.ingredientes.isNotEmpty) ...[
                        Text('Ingredientes:', style: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 13)),
                        Text(fertilizante.ingredientes, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.8), fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                      ],
                      if (fertilizante.elaboracion.isNotEmpty) ...[
                        Text('Instrucciones:', style: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 13)),
                        Text(fertilizante.elaboracion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.8), fontWeight: FontWeight.w700)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (fertilizante.precauciones.isNotEmpty) ...[
                _DetailCard(
                  icon: 'assets/iconos/id.png',
                  title: 'Precauciones',
                  onHelp: () => HelpDialogs.show(context, title: 'Precauciones', text: 'Advertencias importantes.'),
                  child: Text(fertilizante.precauciones, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 12),
              ],
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha rápida',
                onHelp: () => HelpDialogs.show(context, title: 'Ficha rápida', text: 'Datos clave.'),
                child: Column(
                  children: fertilizante.ficha.entries.map((e) => _InfoRow(label: e.key, value: e.value)).toList(),
                ),
              ),
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
  const _InfoRow({required this.label, required this.value});
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
          Expanded(child: Text('$label: $value', style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w700, height: 1.25))),
        ],
      ),
    );
  }
}
