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
  final List<String> ingredientes;
  final List<String> elaboracion;
  final List<String> precauciones;

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
    this.ingredientes = const [],
    this.elaboracion = const [],
    this.precauciones = const [],
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
        'insectos': plagas,
        'ingredientes': ingredientes,
        'elaboracion': elaboracion,
        'precauciones': precauciones,
      };

  static Pesticida fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final plagas =
        (j['insectos'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];

    final ingredientes =
        (j['ingredientes'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];

    final elaboracion =
        (j['elaboracion'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];

    final precauciones =
        (j['precauciones'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];

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
      ingredientes: ingredientes,
      elaboracion: elaboracion,
      precauciones: precauciones,
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
      archive.addFile(
        ArchiveFile(
          'pesticida.json',
          utf8.encode(jsonStr).length,
          utf8.encode(jsonStr),
        ),
      );

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
        final blob = XFile.fromData(
          Uint8List.fromList(zipData),
          name: '${pesticida.nombre}.rdc',
          mimeType: 'application/zip',
        );
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${pesticida.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);
        await Share.shareXFiles(
          [XFile(zipFile.path)],
          text: 'Mira este repelente natural: ${pesticida.nombre}',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir: $e')),
      );
    }
  }

  Widget _buildImage() {
    if (pesticida.imagePath != null && pesticida.imagePath!.isNotEmpty) {
      if (pesticida.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(pesticida.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            pesticida.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded),
          );
        } else {
          return Image.file(
            File(pesticida.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded),
          );
        }
      }
    }

    if (pesticida.imagen.isNotEmpty) {
      return Image.asset(
        pesticida.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded),
      );
    }

    return const Icon(Icons.sanitizer_rounded, color: AppColors.greenDarker);
  }

  Color _tipoColor() {
    final t = pesticida.tipo.toLowerCase();
    if (t.contains('casero')) return const Color(0xFFEAF8EC);
    if (t.contains('orgánico')) return const Color(0xFFE6F7F3);
    if (t.contains('mineral')) return const Color(0xFFF1ECFA);
    return const Color(0xFFF3F8E8);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(
            pesticida.nombre,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
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
                  color: Colors.white.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.greenDark.withOpacity(0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _buildImage(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pesticida.nombre,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.greenDarker,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _tipoColor(),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.greenDark.withOpacity(0.16),
                            ),
                          ),
                          child: Text(
                            pesticida.tipo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.greenDarker,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              _DetailCard(
                icon: 'assets/iconos/id.png',
                title: 'Identificación',
                onHelp: () => HelpDialogs.show(
                  context,
                  title: 'Identificación',
                  text: 'Descripción general del preparado natural.',
                ),
                child: Text(
                  pesticida.identificacion,
                  style: TextStyle(
                    color: AppColors.greenDarker.withOpacity(0.88),
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (pesticida.plagas.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/id.png',
                  title: 'Insectos que combate o repele',
                  onHelp: () => HelpDialogs.show(
                    context,
                    title: 'Insectos',
                    text: 'Insectos relacionados con este preparado.',
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pesticida.plagas
                        .map((p) => _RelatedPestChip(pestName: p))
                        .toList(),
                  ),
                ),

              if (pesticida.plagas.isNotEmpty) const SizedBox(height: 12),

              if (pesticida.ingredientes.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/siembra.png',
                  title: 'Ingredientes',
                  onHelp: () => HelpDialogs.show(
                    context,
                    title: 'Ingredientes',
                    text: 'Ingredientes necesarios para prepararlo.',
                  ),
                  child: Column(
                    children: pesticida.ingredientes
                        .map((e) => _BulletRow(text: e, icon: Icons.check_circle))
                        .toList(),
                  ),
                ),

              if (pesticida.ingredientes.isNotEmpty) const SizedBox(height: 12),

              if (pesticida.elaboracion.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/indirecta.png',
                  title: 'Elaboración paso a paso',
                  onHelp: () => HelpDialogs.show(
                    context,
                    title: 'Elaboración',
                    text: 'Pasos ordenados para prepararlo.',
                  ),
                  child: Column(
                    children: List.generate(
                      pesticida.elaboracion.length,
                      (index) => _StepRow(
                        index: index + 1,
                        text: pesticida.elaboracion[index],
                      ),
                    ),
                  ),
                ),

              if (pesticida.elaboracion.isNotEmpty) const SizedBox(height: 12),

              _DetailCard(
                icon: 'assets/iconos/siembra.png',
                title: 'Uso',
                onHelp: () => HelpDialogs.show(
                  context,
                  title: 'Uso',
                  text: 'Cómo aplicar este preparado.',
                ),
                child: Text(
                  pesticida.uso,
                  style: TextStyle(
                    color: AppColors.greenDarker.withOpacity(0.88),
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (pesticida.precauciones.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/id.png',
                  title: 'Precauciones',
                  onHelp: () => HelpDialogs.show(
                    context,
                    title: 'Precauciones',
                    text: 'Recomendaciones importantes al usarlo.',
                  ),
                  child: Column(
                    children: pesticida.precauciones
                        .map(
                          (e) => _BulletRow(
                            text: e,
                            icon: Icons.warning_amber_rounded,
                          ),
                        )
                        .toList(),
                  ),
                ),

              if (pesticida.precauciones.isNotEmpty) const SizedBox(height: 12),

              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha rápida',
                onHelp: () => HelpDialogs.show(
                  context,
                  title: 'Ficha rápida',
                  text: 'Información resumida del preparado.',
                ),
                child: Column(
                  children: pesticida.ficha.entries
                      .map((e) => _InfoRow(label: e.key, value: e.value))
                      .toList(),
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

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.onHelp,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.greenDark.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                width: 24,
                height: 24,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.info_outline, color: AppColors.greenDarker),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.greenDarker,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: onHelp,
                icon: const Icon(Icons.help_outline_rounded),
                color: AppColors.greenDarker,
              ),
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

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.greenDark.withOpacity(0.14),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: AppColors.greenDark,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.greenDarker,
                  height: 1.35,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  final IconData icon;

  const _BulletRow({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.greenDark.withOpacity(0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.greenDark, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int index;
  final String text;

  const _StepRow({
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.greenDark.withOpacity(0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.greenDark,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
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
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        try {
          final raw = await rootBundle.loadString('assets/data/plagas.json');
          final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
          final decoded = jsonDecode(cleanJson) as List;
          final catalog = decoded
              .map((e) => Plaga.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          final plaga = catalog.firstWhere(
            (p) => p.nombre.toLowerCase() == pestName.toLowerCase(),
          );

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlagaDetallePage(plaga: plaga),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se encontró detalle para: $pestName')),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.greenDark.withOpacity(0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bug_report_rounded,
              size: 16,
              color: AppColors.greenDarker,
            ),
            const SizedBox(width: 6),
            Text(
              pestName,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.greenDarker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}