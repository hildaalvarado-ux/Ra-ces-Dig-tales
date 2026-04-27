import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/db_instance.dart';
import '../main.dart';
import 'help_dialogs.dart';

class ControlOption {
  final String titulo;
  final String descripcion;

  const ControlOption({required this.titulo, required this.descripcion});

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'descripcion': descripcion,
      };

  factory ControlOption.fromJson(Map<String, dynamic> j) {
    return ControlOption(
      titulo: (j['titulo'] ?? '').toString(),
      descripcion: (j['descripcion'] ?? '').toString(),
    );
  }
}

class Enfermedad {
  final int? id;
  final String nombre;
  final String tipo;
  final String descripcion;
  final String aparece;
  final String prevencion;
  final List<ControlOption> control;
  final String imagen;
  final String? imagePath;
  final Map<String, String> ficha;

  const Enfermedad({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
    required this.aparece,
    required this.prevencion,
    required this.control,
    required this.imagen,
    this.imagePath,
    required this.ficha,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'tipo': tipo,
        'descripcion': descripcion,
        'aparece': aparece,
        'prevencion': prevencion,
        'control': control.map((e) => e.toJson()).toList(),
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        'ficha': ficha,
      };

  static Enfermedad fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final controlList = (j['control'] as List?)
            ?.map((e) => ControlOption.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];

    return Enfermedad(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      tipo: (j['tipo'] ?? '').toString(),
      descripcion: (j['descripcion'] ?? '').toString(),
      aparece: (j['aparece'] ?? '').toString(),
      prevencion: (j['prevencion'] ?? '').toString(),
      control: controlList,
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      ficha: ficha,
    );
  }
}

class EnfermedadDetallePage extends StatefulWidget {
  final Enfermedad enfermedad;
  const EnfermedadDetallePage({super.key, required this.enfermedad});

  @override
  State<EnfermedadDetallePage> createState() => _EnfermedadDetallePageState();
}

class _EnfermedadDetallePageState extends State<EnfermedadDetallePage> {
  int _selectedControlIndex = 0;

  Future<void> _share(BuildContext context) async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      final jsonStr = jsonEncode(widget.enfermedad.toJson());
      archive.addFile(ArchiveFile('enfermedad.json', jsonStr.length, utf8.encode(jsonStr)));

      if (widget.enfermedad.imagePath != null && widget.enfermedad.imagePath!.isNotEmpty) {
        if (widget.enfermedad.imagePath!.startsWith('data:image')) {
          final parts = widget.enfermedad.imagePath!.split(',');
          final bytes = base64Decode(parts.last);
          final ext = parts.first.split('/').last.split(';').first;
          archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
        } else {
          final file = File(widget.enfermedad.imagePath!);
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
            name: '${widget.enfermedad.nombre}.rdc', mimeType: 'application/zip');
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${widget.enfermedad.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);
        await Share.shareXFiles([XFile(zipFile.path)], text: 'Mira esta enfermedad: ${widget.enfermedad.nombre}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  Widget _buildImage() {
    if (widget.enfermedad.imagePath != null && widget.enfermedad.imagePath!.isNotEmpty) {
      if (widget.enfermedad.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(widget.enfermedad.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            widget.enfermedad.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(widget.enfermedad.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      }
    }
    if (widget.enfermedad.imagen.isNotEmpty) {
      return Image.asset(
        widget.enfermedad.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.biotech_rounded),
      );
    }
    return const Icon(Icons.biotech_rounded, color: AppColors.greenDarker, size: 64);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(widget.enfermedad.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _buildImage(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.enfermedad.descripcion,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greenDarker,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/id.png',
                title: '¿Cuándo aparece?',
                onHelp: () => HelpDialogs.show(context, title: 'Aparición', text: 'Condiciones ambientales que favorecen la enfermedad.'),
                child: Text(widget.enfermedad.aparece, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/siembra.png',
                title: 'Prevención',
                onHelp: () => HelpDialogs.show(context, title: 'Prevención', text: 'Acciones para evitar que la enfermedad ataque su huerto.'),
                child: Text(widget.enfermedad.prevencion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Métodos de Control',
                onHelp: () => HelpDialogs.show(context, title: 'Control', text: 'Opciones para tratar la enfermedad una vez detectada.'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.enfermedad.control.length > 1) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(widget.enfermedad.control.length, (index) {
                            final isSelected = _selectedControlIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(widget.enfermedad.control[index].titulo),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) setState(() => _selectedControlIndex = index);
                                },
                                selectedColor: AppColors.greenDark,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.greenDarker,
                                  fontWeight: FontWeight.w800,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greenDark.withOpacity(0.1)),
                      ),
                      child: Text(
                        widget.enfermedad.control[_selectedControlIndex].descripcion,
                        style: const TextStyle(
                          color: AppColors.greenDarker,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha Técnica',
                onHelp: () => HelpDialogs.show(context, title: 'Ficha Técnica', text: 'Datos clave resumidos.'),
                child: Column(
                  children: widget.enfermedad.ficha.entries.map((e) => _InfoRow(label: e.key, value: e.value)).toList(),
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
