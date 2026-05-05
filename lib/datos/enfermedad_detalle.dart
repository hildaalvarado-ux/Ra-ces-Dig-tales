import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/file_management_service.dart';
import '../data/db_instance.dart';
import '../data/catalog_manager.dart';
import '../main.dart';
import 'help_dialogs.dart';
import 'plaga_detalle.dart';
import 'pesticida_detalle.dart';

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
  List<dynamic> _relatedItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRelatedData();
  }

  Future<void> _loadRelatedData() async {
    try {
      final pests = await catalogManager.getPests();
      final pesticides = await catalogManager.getPesticides();

      final String diseaseText = [
        widget.enfermedad.nombre,
        widget.enfermedad.descripcion,
        widget.enfermedad.aparece,
        widget.enfermedad.prevencion,
        ...widget.enfermedad.control.map((e) => e.descripcion),
      ].join(' ').toLowerCase();

      final List<dynamic> related = [];

      // Match Pesticides
      for (var p in pesticides) {
        final pName = p.nombre.toLowerCase();
        bool match = false;

        if (diseaseText.contains(pName)) {
          match = true;
        } else {
          // Check for significant keywords
          final keywords = [
            'apichi', 'bordelés', 'ceniza', 'jengibre', 'leche',
            'bicarbonato', 'sábila', 'albahaca', 'canela', 'lejía',
            'ajo', 'epacina', 'silico', 'jabón'
          ];
          for (var kw in keywords) {
            if (pName.contains(kw) && diseaseText.contains(kw)) {
              // Special case: don't match "Caldo Ceniza" if only "Lejía de ceniza" is mentioned
              if (kw == 'ceniza' && !diseaseText.contains('caldo') && pName.contains('caldo')) continue;
              if (kw == 'ceniza' && !diseaseText.contains('lejía') && pName.contains('lejía')) continue;

              match = true;
              break;
            }
          }
        }

        if (match && !related.contains(p)) {
          related.add(p);
        }
      }

      // Match Pests (Vectors)
      for (var p in pests) {
        final pName = p.nombre.toLowerCase();
        if (diseaseText.contains(pName)) {
          if (!related.contains(p)) {
            related.add(p);
          }
        } else if (widget.enfermedad.nombre.toLowerCase() == 'virosis' &&
                   (pName == 'mosca blanca' || pName == 'pulgones' || pName == 'trips' || pName == 'chicharrita')) {
          // Virosis explicitly mentions insect vectors
          if (!related.contains(p)) {
            related.add(p);
          }
        }
      }

      if (mounted) {
        setState(() {
          _relatedItems = related;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading related data: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _share(BuildContext context) async {
    await fileManagementService.shareModuleData(
      module: 'enfermedad',
      name: widget.enfermedad.nombre,
      data: widget.enfermedad.toJson(),
      imagePath: widget.enfermedad.imagePath,
      text: 'Mira esta enfermedad: ${widget.enfermedad.nombre}',
    );
  }

  Future<void> _download(BuildContext context) async {
    final result = await fileManagementService.saveModuleData(
      module: 'enfermedad',
      name: widget.enfermedad.nombre,
      data: widget.enfermedad.toJson(),
      imagePath: widget.enfermedad.imagePath,
    );

    if (!context.mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descarga exitosa. Archivo guardado en $result'),
          backgroundColor: AppColors.greenDark,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al descargar el archivo')),
      );
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
              tooltip: 'Descargar info',
              onPressed: () => _download(context),
              icon: const Icon(Icons.download_rounded),
            ),
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
              if (_relatedItems.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailCard(
                  icon: 'assets/iconos/siembra.png',
                  title: 'Relacionado con repelente e insectos',
                  onHelp: () => HelpDialogs.show(context, title: 'Relacionados', text: 'Repelentes recomendados e insectos que pueden transmitir esta enfermedad.'),
                  child: SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _relatedItems.length,
                      itemBuilder: (context, index) {
                        final item = _relatedItems[index];
                        if (item is Pesticida) {
                          return _RelatedItemLink(
                            nombre: 'Repelente: ${item.nombre}',
                            imagen: item.imagen,
                            imagePath: item.imagePath,
                            icon: Icons.sanitizer_rounded,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PesticidaDetallePage(pesticida: item))),
                          );
                        } else if (item is Plaga) {
                          return _RelatedItemLink(
                            nombre: 'Vector: ${item.nombre}',
                            imagen: item.imagen,
                            imagePath: item.imagePath,
                            icon: Icons.bug_report_rounded,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlagaDetallePage(plaga: item))),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
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

class _RelatedItemLink extends StatelessWidget {
  final String nombre;
  final String imagen;
  final String? imagePath;
  final IconData icon;
  final VoidCallback onTap;

  const _RelatedItemLink({
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greenDark.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nombre,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: AppColors.greenDarker,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(icon),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(icon),
          );
        } else {
          return Image.file(
            File(imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(icon),
          );
        }
      }
    }
    if (imagen.isNotEmpty) {
      return Image.asset(
        imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(icon),
      );
    }
    return Icon(icon, color: AppColors.greenDarker);
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
