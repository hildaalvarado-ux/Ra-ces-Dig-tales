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

  const Fertilizante({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.tipo,
    required this.identificacion,
    required this.uso,
    required this.ficha,
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
        return Image.file(
          File(fertilizante.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
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
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Identificación',
                      onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Descripción del fertilizante.'),
                    ),
                    Text(fertilizante.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Modo de Uso',
                      onHelp: () => HelpDialogs.show(context, title: 'Modo de Uso', text: 'Cómo aplicar este fertilizante.'),
                    ),
                    Text(fertilizante.uso, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Ficha rápida',
                      onHelp: () => HelpDialogs.show(context, title: 'Ficha rápida', text: 'Datos clave.'),
                    ),
                    const SizedBox(height: 8),
                    ...fertilizante.ficha.entries.map((e) => _InfoRow(label: e.key, value: e.value)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: child,
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onHelp;
  const _HeaderRow({required this.title, required this.onHelp});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 16)),
        const Spacer(),
        IconButton(onPressed: onHelp, icon: const Icon(Icons.help_outline_rounded), color: AppColors.greenDarker),
      ],
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
      child: Text('$label: $value', style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w700, height: 1.25)),
    );
  }
}
