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

class Plaga {
  final int? id;
  final String nombre;
  final String cientifico;
  final String imagen;
  final String? imagePath;
  final String identificacion;
  final String sintomas;
  final String control;
  final Map<String, String> ficha;

  const Plaga({
    this.id,
    required this.nombre,
    required this.cientifico,
    required this.imagen,
    this.imagePath,
    required this.identificacion,
    required this.sintomas,
    required this.control,
    required this.ficha,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'cientifico': cientifico,
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        'identificacion': identificacion,
        'sintomas': sintomas,
        'control': control,
        'ficha': ficha,
      };

  static Plaga fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    return Plaga(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      cientifico: (j['cientifico'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      sintomas: (j['sintomas'] ?? '').toString(),
      control: (j['control'] ?? '').toString(),
      ficha: ficha,
    );
  }
}

class PlagaDetallePage extends StatelessWidget {
  final Plaga plaga;
  const PlagaDetallePage({super.key, required this.plaga});

  Future<void> _share(BuildContext context) async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      final jsonStr = jsonEncode(plaga.toJson());
      archive.addFile(ArchiveFile('plaga.json', jsonStr.length, utf8.encode(jsonStr)));

      if (plaga.imagePath != null && plaga.imagePath!.isNotEmpty) {
        if (plaga.imagePath!.startsWith('data:image')) {
          final parts = plaga.imagePath!.split(',');
          final bytes = base64Decode(parts.last);
          final ext = parts.first.split('/').last.split(';').first;
          archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
        } else {
          final file = File(plaga.imagePath!);
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
            name: '${plaga.nombre}.rdc', mimeType: 'application/zip');
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${plaga.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);
        await Share.shareXFiles([XFile(zipFile.path)], text: 'Mira esta plaga: ${plaga.nombre}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  Widget _buildImage() {
    if (plaga.imagePath != null && plaga.imagePath!.isNotEmpty) {
      if (plaga.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(plaga.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        return Image.file(
          File(plaga.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      }
    }
    if (plaga.imagen.isNotEmpty) {
      return Image.asset(
        plaga.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.bug_report_rounded),
      );
    }
    return const Icon(Icons.bug_report_rounded, color: AppColors.greenDarker, size: 64);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(plaga.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
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
                      onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Cómo reconocer la plaga.'),
                    ),
                    Text(plaga.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                    if (plaga.cientifico.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(plaga.cientifico, style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Síntomas',
                      onHelp: () => HelpDialogs.show(context, title: 'Síntomas', text: 'Daños que causa en el cultivo.'),
                    ),
                    Text(plaga.sintomas, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Control',
                      onHelp: () => HelpDialogs.show(context, title: 'Control', text: 'Cómo combatir esta plaga.'),
                    ),
                    Text(plaga.control, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
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
                    ...plaga.ficha.entries.map((e) => _InfoRow(label: e.key, value: e.value)),
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
