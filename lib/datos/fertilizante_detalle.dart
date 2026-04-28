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

class Fertilizante {
  final int? id;
  final String nombre;
  final String imagen;
  final String? imagePath;
  final String tipo;
  final String identificacion;
  final String uso;
  final Map<String, String> ficha;
  final List<String> ingredientes;
  final List<String> elaboracion;
  final List<String> precauciones;
  final bool esCasero;
  final String dificultad;
  final String faseAplicacion;
  final List<String> plagas;

  const Fertilizante({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.tipo,
    required this.identificacion,
    required this.uso,
    required this.ficha,
    this.ingredientes = const [],
    this.elaboracion = const [],
    this.precauciones = const [],
    this.esCasero = false,
    this.dificultad = '',
    this.faseAplicacion = '',
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
        'ingredientes': ingredientes,
        'elaboracion': elaboracion,
        'precauciones': precauciones,
        'esCasero': esCasero,
        'dificultad': dificultad,
        'faseAplicacion': faseAplicacion,
        'insectos': plagas,
      };

  static Fertilizante fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final plagas = (j['insectos'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    final ingredientes = (j['ingredientes'] is List)
        ? (j['ingredientes'] as List).map((e) => e.toString()).toList()
        : (j['ingredientes'] != null && j['ingredientes'].toString().isNotEmpty)
            ? [j['ingredientes'].toString()]
            : <String>[];

    final elaboracion = (j['elaboracion'] is List)
        ? (j['elaboracion'] as List).map((e) => e.toString()).toList()
        : (j['elaboracion'] != null && j['elaboracion'].toString().isNotEmpty)
            ? [j['elaboracion'].toString()]
            : <String>[];

    final precauciones = (j['precauciones'] is List)
        ? (j['precauciones'] as List).map((e) => e.toString()).toList()
        : (j['precauciones'] != null && j['precauciones'].toString().isNotEmpty)
            ? [j['precauciones'].toString()]
            : <String>[];

    return Fertilizante(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      tipo: (j['tipo'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      uso: (j['uso'] ?? '').toString(),
      ficha: ficha,
      ingredientes: ingredientes,
      elaboracion: elaboracion,
      precauciones: precauciones,
      esCasero: j['esCasero'] ?? false,
      dificultad: (j['dificultad'] ?? '').toString(),
      faseAplicacion: (j['faseAplicacion'] ?? '').toString(),
      plagas: plagas,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greenDark.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bug_report_rounded, size: 16, color: AppColors.greenDarker),
            const SizedBox(width: 6),
            Text(pestName, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.greenDarker)),
          ],
        ),
      ),
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
          errorBuilder: (_, __, ___) => const Icon(Icons.science_rounded),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            fertilizante.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.science_rounded),
          );
        } else {
          return Image.file(
            File(fertilizante.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.science_rounded),
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
    return const Icon(Icons.science_rounded, color: AppColors.greenDarker);
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
              if (fertilizante.plagas.isNotEmpty) ...[
                _DetailCard(
                  icon: 'assets/iconos/id.png',
                  title: 'Insectos que combate o repele',
                  onHelp: () => HelpDialogs.show(context, title: 'Insectos', text: 'Insectos que este fertilizante ayuda a controlar.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fertilizante.plagas.map((p) => _RelatedPestChip(pestName: p)).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
                        Text('Ingredientes:', style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 13)),
                        const SizedBox(height: 8),
                        ...fertilizante.ingredientes.map((e) => _BulletRow(text: e, icon: Icons.check_circle)),
                        const SizedBox(height: 10),
                      ],
                      if (fertilizante.elaboracion.isNotEmpty) ...[
                        Text('Instrucciones:', style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 13)),
                        const SizedBox(height: 8),
                        ...List.generate(
                          fertilizante.elaboracion.length,
                          (index) => _StepRow(
                            index: index + 1,
                            text: fertilizante.elaboracion[index],
                          ),
                        ),
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
                  child: Column(
                    children: fertilizante.precauciones
                        .map(
                          (e) => _BulletRow(
                            text: e,
                            icon: Icons.warning_amber_rounded,
                          ),
                        )
                        .toList(),
                  ),
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
              Expanded(child: Text(title, style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 16))),
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
