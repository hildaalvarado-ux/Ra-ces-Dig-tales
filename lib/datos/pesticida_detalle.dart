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
import 'plaga_detalle.dart';

class Pesticida {
  final int? id;
  final String nombre;
  final String imagen;
  final String? imagePath;
  final String tipo;
  final String identificacion;
  final String uso;
  final Map<String, String> ficha;
  final List<String> plagas;

  const Pesticida({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.tipo,
    required this.identificacion,
    required this.uso,
    required this.ficha,
    this.plagas = const [],
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
        'plagas': plagas,
      };

  static Pesticida fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};
    final plagas = (j['plagas'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    return Pesticida(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      tipo: (j['tipo'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      uso: (j['uso'] ?? '').toString(),
      ficha: ficha,
      plagas: plagas,
    );
  }
}

class PesticidaDetallePage extends StatelessWidget {
  final Pesticida pesticida;
  const PesticidaDetallePage({super.key, required this.pesticida});

  Future<void> _share(BuildContext context) async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      final jsonStr = jsonEncode(pesticida.toJson());
      archive.addFile(ArchiveFile('pesticida.json', jsonStr.length, utf8.encode(jsonStr)));

      if (pesticida.imagePath != null && pesticida.imagePath!.isNotEmpty) {
        if (pesticida.imagePath!.startsWith('data:image')) {
          final parts = pesticida.imagePath!.split(',');
          final bytes = base64Decode(parts.last);
          final ext = parts.first.split('/').last.split(';').first;
          archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
        } else {
          final file = File(pesticida.imagePath!);
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
            name: '${pesticida.nombre}.rdc', mimeType: 'application/zip');
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${pesticida.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);
        await Share.shareXFiles([XFile(zipFile.path)], text: 'Mira este pesticida: ${pesticida.nombre}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  Widget _buildImage() {
    if (pesticida.imagePath != null && pesticida.imagePath!.isNotEmpty) {
      if (pesticida.imagePath!.startsWith('data:image')) {
        return Image.memory(base64Decode(pesticida.imagePath!.split(',').last), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
      } else {
        return Image.file(File(pesticida.imagePath!), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
      }
    }
    if (pesticida.imagen.isNotEmpty) {
      return Image.asset(pesticida.imagen, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded));
    }
    return const Icon(Icons.sanitizer_rounded, color: AppColors.greenDarker, size: 64);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(pesticida.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
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
                onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Descripción del pesticida.'),
                child: Text(pesticida.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/siembra.png', // Reusing icons where appropriate
                title: 'Modo de Uso',
                onHelp: () => HelpDialogs.show(context, title: 'Modo de Uso', text: 'Cómo aplicar este pesticida.'),
                child: Text(pesticida.uso, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              if (pesticida.plagas.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/id.png',
                  title: 'Plagas que combate',
                  onHelp: () => HelpDialogs.show(context, title: 'Plagas', text: 'Plagas que este producto elimina o repele.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pesticida.plagas.map((p) => _RelatedPestChip(pestName: p)).toList(),
                  ),
                ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha rápida',
                onHelp: () => HelpDialogs.show(context, title: 'Ficha rápida', text: 'Datos clave.'),
                child: Column(
                  children: pesticida.ficha.entries.map((e) => _InfoRow(label: e.key, value: e.value)).toList(),
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

class _RelatedPestChip extends StatelessWidget {
  final String pestName;
  const _RelatedPestChip({required this.pestName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final raw = await rootBundle.loadString('assets/data/plagas.json');
          final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
          final decoded = jsonDecode(cleanJson) as List;
          final catalog = decoded.map((e) => Plaga.fromJson(Map<String, dynamic>.from(e))).toList();
          final plaga = catalog.firstWhere((p) => p.nombre.toLowerCase() == pestName.toLowerCase());
          if (context.mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PlagaDetallePage(plaga: plaga)));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se encontró detalle para: $pestName')));
          }
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
            const Icon(Icons.bug_report_rounded, size: 16, color: AppColors.greenDarker),
            const SizedBox(width: 4),
            Text(pestName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.greenDarker)),
          ],
        ),
      ),
    );
  }
}
