import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/db_instance.dart';
import '../data/catalog_manager.dart';
import '../data/image_utils.dart';
import '../main.dart';
import 'fertilizante_detalle.dart';

class FertilizantesPage extends StatefulWidget {
  final int userId;
  const FertilizantesPage({super.key, required this.userId});

  @override
  State<FertilizantesPage> createState() => _FertilizantesPageState();
}

class _FertilizantesPageState extends State<FertilizantesPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;
  final List<Fertilizante> _catalogo = [];
  final List<Fertilizante> _agregados = [];
  final List<Fertilizante> _compartidos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _loading = true);
    try {
      await _loadCatalog();
      await _loadUserFertilizantes();
      await _loadSharedFertilizantes();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCatalog() async {
    final list = await catalogManager.getFertilizers();
    _catalogo.clear();
    _catalogo.addAll(list);
  }

  Future<void> _loadUserFertilizantes() async {
    final list = await appDb.getUserFertilizantes(widget.userId);
    _agregados.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _agregados.add(Fertilizante.fromJson(data));
    }
  }

  Future<void> _loadSharedFertilizantes() async {
    final list = await appDb.getSharedFertilizantes(widget.userId);
    _compartidos.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _compartidos.add(Fertilizante.fromJson(data));
    }
  }

  List<Fertilizante> _applyFilters(List<Fertilizante> list) {
    final q = _searchCtrl.text.toLowerCase();
    return list.where((f) => f.nombre.toLowerCase().contains(q) || f.tipo.toLowerCase().contains(q)).toList();
  }

  List<Fertilizante> get _filteredCatalogo => _applyFilters(_catalogo);
  List<Fertilizante> get _filteredAgregados => _applyFilters(_agregados);
  List<Fertilizante> get _filteredCompartidos => _applyFilters(_compartidos);

  Future<void> _importFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['rdc'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      final bytes = picked.bytes ?? (picked.path != null ? await File(picked.path!).readAsBytes() : null);

      if (bytes == null) throw Exception('No se pudieron leer los bytes del archivo');

      final jsonContent = utf8.decode(bytes);
      final data = jsonDecode(jsonContent) as Map<String, dynamic>;
      final temp = Fertilizante.fromJson(data);

      String? savedImagePath;
      if (data['image_exported'] != null) {
        final imageUri = data['image_exported'] as String;
        final parts = imageUri.split(',');
        if (parts.length >= 2) {
          final mime = parts[0].split(':')[1].split(';')[0];
          final ext = mime.split('/')[1];
          final imgBytes = base64Decode(parts[1]);
          savedImagePath = await ImageUtils.saveImageBytes(
            imgBytes,
            'fertilizantes_images',
            ext,
          );
        }
      }

      await appDb.insertSharedFertilizante(
        userId: widget.userId,
        nombre: temp.nombre,
        tipo: temp.tipo,
        imagePath: savedImagePath,
        payloadJson: jsonEncode(temp.toJson()),
      );

      await _loadData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Importado correctamente: ${temp.nombre}'),
          backgroundColor: AppColors.greenDark,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar: $e')),
      );
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
          title: const Text('Fertilizantes', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar fertilizante...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.85),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            if (_filteredAgregados.isNotEmpty) ...[
                              _buildSectionHeader('Mis fertilizantes'),
                              ..._filteredAgregados.map((f) => _FertilizanteTile(fertilizante: f)),
                            ],
                            if (_filteredCompartidos.isNotEmpty) ...[
                              _buildSectionHeader('Compartidos'),
                              ..._filteredCompartidos.map((f) => _FertilizanteTile(fertilizante: f)),
                            ],
                            if (_filteredCatalogo.isNotEmpty) ...[
                              _buildSectionHeader(
                                'Catálogo',
                                action: IconButton(
                                  visualDensity: VisualDensity.compact,
                                  tooltip: 'Importar desde archivo .rdc',
                                  icon: const Icon(Icons.download_rounded, size: 20),
                                  onPressed: _importFromFile,
                                  color: AppColors.greenDark,
                                ),
                              ),
                              ..._filteredCatalogo.map((f) => _FertilizanteTile(fertilizante: f)),
                            ],
                            if (_filteredCatalogo.isEmpty && _filteredAgregados.isEmpty && _filteredCompartidos.isEmpty)
                              const Center(child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No se encontraron fertilizantes'),
                              )),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppColors.greenDarker.withOpacity(0.6),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }
}

class _FertilizanteTile extends StatelessWidget {
  final Fertilizante fertilizante;
  const _FertilizanteTile({required this.fertilizante});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white.withOpacity(0.82),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.greenDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildImage(),
          ),
        ),
        title: Text(fertilizante.nombre, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
        subtitle: Text(fertilizante.tipo),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FertilizanteDetallePage(fertilizante: fertilizante))),
      ),
    );
  }

  Widget _buildImage() {
    if (fertilizante.imagePath != null && fertilizante.imagePath!.isNotEmpty) {
      if (fertilizante.imagePath!.startsWith('data:image')) {
        return Image.memory(base64Decode(fertilizante.imagePath!.split(',').last), fit: BoxFit.cover);
      } else {
        if (kIsWeb) {
          return Image.network(fertilizante.imagePath!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
        } else {
          return Image.file(File(fertilizante.imagePath!), fit: BoxFit.cover);
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
}
