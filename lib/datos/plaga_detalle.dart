import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/db_instance.dart';
import '../data/catalog_manager.dart';
import '../main.dart';
import 'help_dialogs.dart';
import 'cultivo_detalle.dart';
import 'pesticida_detalle.dart';
import 'fertilizante_detalle.dart';

class Plaga {
  final int? id;
  final String nombre;
  final String cientifico;
  final String imagen;
  final String? imagePath;
  final String? imagenVisual; // New field for visual identification
  final String descripcion; // New field
  final String identificacion;
  final String sintomas;
  final String danos; // New field (replacing/merging with sintomas in UI if needed)
  final String causas;
  final String control;
  final Map<String, String> ficha;

  const Plaga({
    this.id,
    required this.nombre,
    required this.cientifico,
    required this.imagen,
    this.imagePath,
    this.imagenVisual,
    required this.descripcion,
    required this.identificacion,
    required this.sintomas,
    required this.danos,
    required this.causas,
    required this.control,
    required this.ficha,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'cientifico': cientifico,
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        if (imagenVisual != null) 'imagenVisual': imagenVisual,
        'descripcion': descripcion,
        'identificacion': identificacion,
        'sintomas': sintomas,
        'danos': danos,
        'causas': causas,
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
      imagenVisual: j['imagenVisual']?.toString(),
      descripcion: (j['descripcion'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      sintomas: (j['sintomas'] ?? '').toString(),
      danos: (j['danos'] ?? '').toString(),
      causas: (j['causas'] ?? '').toString(),
      control: (j['control'] ?? '').toString(),
      ficha: ficha,
    );
  }
}

class _RelatedItemLink extends StatelessWidget {
  final String nombre;
  final String imagen;
  final String? imagePath;
  final VoidCallback onTap;

  const _RelatedItemLink({
    required this.nombre,
    required this.imagen,
    this.imagePath,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
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
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      }
    }
    if (imagen.isNotEmpty) {
      return Image.asset(
        imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_rounded),
      );
    }
    return const Icon(Icons.image_not_supported_rounded, color: AppColors.greenDarker);
  }
}

class PlagaDetallePage extends StatefulWidget {
  final Plaga plaga;
  const PlagaDetallePage({super.key, required this.plaga});

  @override
  State<PlagaDetallePage> createState() => _PlagaDetallePageState();
}

class _PlagaDetallePageState extends State<PlagaDetallePage> {
  int? _userId;
  List<dynamic> _affectedCrops = [];
  List<dynamic> _relatedControls = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRelatedData();
  }

  Future<void> _loadRelatedData() async {
    try {
      _userId = await appDb.getActiveUserId();

      final crops = await catalogManager.getCrops();
      final pesticides = await catalogManager.getPesticides();
      final fertilizers = await catalogManager.getFertilizers();

      List<dynamic> userCrops = [];
      if (_userId != null) {
        final rows = await appDb.getUserCultivos(_userId!);
        userCrops = rows.map((r) {
          final data = jsonDecode(r.payloadJson) as Map<String, dynamic>;
          data['id'] = r.id;
          data['imagePath'] = r.imagePath;
          return Cultivo.fromJson(data);
        }).toList();
      }

      final allCrops = [...crops, ...userCrops];
      _affectedCrops = allCrops.where((c) => c.plagas.any((p) => p.toLowerCase() == widget.plaga.nombre.toLowerCase())).toList();

      final relatedPesticides = pesticides.where((p) => p.plagas.any((pest) => pest.toLowerCase() == widget.plaga.nombre.toLowerCase())).toList();
      final relatedFertilizers = fertilizers.where((f) => f.plagas.any((pest) => pest.toLowerCase() == widget.plaga.nombre.toLowerCase())).toList();

      _relatedControls = [...relatedPesticides, ...relatedFertilizers];

    } catch (e) {
      debugPrint('Error loading related data: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _share(BuildContext context) async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      final jsonStr = jsonEncode(widget.plaga.toJson());
      archive.addFile(ArchiveFile('insecto.json', jsonStr.length, utf8.encode(jsonStr)));

      if (widget.plaga.imagePath != null && widget.plaga.imagePath!.isNotEmpty) {
        if (widget.plaga.imagePath!.startsWith('data:image')) {
          final parts = widget.plaga.imagePath!.split(',');
          final bytes = base64Decode(parts.last);
          final ext = parts.first.split('/').last.split(';').first;
          archive.addFile(ArchiveFile('imagen.$ext', bytes.length, bytes));
        } else {
          final file = File(widget.plaga.imagePath!);
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
            name: '${widget.plaga.nombre}.rdc', mimeType: 'application/zip');
        await Share.shareXFiles([blob]);
      } else {
        final tempDir = await getTemporaryDirectory();
        final zipFile = File('${tempDir.path}/${widget.plaga.nombre}.rdc');
        await zipFile.writeAsBytes(zipData);
        await Share.shareXFiles([XFile(zipFile.path)], text: 'Mira este insecto: ${widget.plaga.nombre}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  Widget _buildImage({String? path, String? asset, double height = 180}) {
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('data:image')) {
        return Image.memory(
          base64Decode(path.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      }
    }
    if (asset != null && asset.isNotEmpty) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(widget.plaga.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
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
                        child: _buildImage(path: widget.plaga.imagePath, asset: widget.plaga.imagen),
                      ),
                    ),
                    if (widget.plaga.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        widget.plaga.descripcion,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greenDarker,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/id.png',
                title: 'Identificación en campo',
                onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Características para reconocerlo visualmente.'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.plaga.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                    if (widget.plaga.cientifico.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(widget.plaga.cientifico, style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
                    ],
                    if (widget.plaga.imagenVisual != null && widget.plaga.imagenVisual!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text('Referencia visual:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.greenDarker)),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: _buildImage(asset: widget.plaga.imagenVisual),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/verano.png',
                title: 'Daños y síntomas',
                onHelp: () => HelpDialogs.show(context, title: 'Daños', text: 'Impacto del insecto en el cultivo.'),
                child: Text(
                  widget.plaga.danos.isNotEmpty ? widget.plaga.danos : widget.plaga.sintomas,
                  style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/id.png',
                title: 'Causas de aparición',
                onHelp: () => HelpDialogs.show(context, title: 'Causas', text: 'Factores que favorecen su presencia.'),
                child: Text(widget.plaga.causas.isEmpty ? 'Información no disponible.' : widget.plaga.causas, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              if (_affectedCrops.isNotEmpty) ...[
                _DetailCard(
                  icon: 'assets/iconos/siembra.png',
                  title: 'Cultivos sensibles',
                  onHelp: () => HelpDialogs.show(context, title: 'Cultivos', text: 'Plantas que suelen ser atacadas.'),
                  child: SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _affectedCrops.length,
                      itemBuilder: (context, index) {
                        final c = _affectedCrops[index] as Cultivo;
                        return _RelatedItemLink(
                          nombre: c.nombre,
                          imagen: c.imagen,
                          imagePath: c.imagePath,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CultivoDetallePage(cultivo: c))),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _DetailCard(
                icon: 'assets/iconos/siembra.png',
                title: 'Métodos de control',
                onHelp: () => HelpDialogs.show(context, title: 'Control', text: 'Estrategias para combatir al insecto.'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.plaga.control, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
                    if (_relatedControls.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text('Soluciones recomendadas:', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker, fontSize: 13)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _relatedControls.length,
                          itemBuilder: (context, index) {
                            final item = _relatedControls[index];
                            if (item is Pesticida) {
                              return _RelatedItemLink(
                                nombre: item.nombre,
                                imagen: item.imagen,
                                imagePath: item.imagePath,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PesticidaDetallePage(pesticida: item))),
                              );
                            } else if (item is Fertilizante) {
                              return _RelatedItemLink(
                                nombre: item.nombre,
                                imagen: item.imagen,
                                imagePath: item.imagePath,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FertilizanteDetallePage(fertilizante: item))),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha técnica resumida',
                onHelp: () => HelpDialogs.show(context, title: 'Ficha técnica', text: 'Datos clave y rápidos.'),
                child: Column(
                  children: widget.plaga.ficha.entries.map((e) => _InfoRow(label: e.key, value: e.value)).toList(),
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
