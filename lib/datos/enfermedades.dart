import '../data/common_widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/db_instance.dart';
import '../data/catalog_manager.dart';
import '../data/image_utils.dart';
import '../main.dart';
import 'enfermedad_detalle.dart';

class EnfermedadesPage extends StatefulWidget {
  final int userId;
  const EnfermedadesPage({super.key, required this.userId});

  @override
  State<EnfermedadesPage> createState() => _EnfermedadesPageState();
}

class _EnfermedadesPageState extends State<EnfermedadesPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;
  final List<Enfermedad> _catalogo = [];
  final List<Enfermedad> _agregados = [];
  final List<Enfermedad> _compartidos = [];
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _loading = true);
    try {
      await _loadCatalog();
      await _loadUserEnfermedades();
      await _loadSharedEnfermedades();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCatalog() async {
    final list = await catalogManager.getDiseases();
    _catalogo.clear();
    _catalogo.addAll(list);
  }

  Future<void> _loadUserEnfermedades() async {
    final list = await appDb.getUserEnfermedades(widget.userId);
    _agregados.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _agregados.add(Enfermedad.fromJson(data));
    }
  }

  Future<void> _loadSharedEnfermedades() async {
    final list = await appDb.getSharedEnfermedades(widget.userId);
    _compartidos.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _compartidos.add(Enfermedad.fromJson(data));
    }
  }

  List<Enfermedad> _applyFilters(List<Enfermedad> list) {
    final q = _searchCtrl.text.toLowerCase();
    return list.where((p) {
      final matchesSearch = p.nombre.toLowerCase().contains(q) ||
          p.tipo.toLowerCase().contains(q) ||
          p.descripcion.toLowerCase().contains(q);

      if (_selectedFilter == 'Todos') return matchesSearch;
      return matchesSearch && p.tipo.contains(_selectedFilter);
    }).toList();
  }

  List<Enfermedad> get _filteredCatalogo => _applyFilters(_catalogo);
  List<Enfermedad> get _filteredAgregados => _applyFilters(_agregados);
  List<Enfermedad> get _filteredCompartidos => _applyFilters(_compartidos);

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
      final temp = Enfermedad.fromJson(data);

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
            'enfermedades_images',
            ext,
          );
        }
      }

      await appDb.insertSharedEnfermedad(
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
          title: const Text(
            'Enfermedades',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
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
                    hintText: 'Buscar enfermedad...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.85),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Todos', 'Hongo', 'Bacteria', 'Virus', 'Nematodo'].map((f) {
                      final isSelected = _selectedFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedFilter = f);
                          },
                          selectedColor: AppColors.greenDark,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.greenDarker,
                            fontWeight: FontWeight.w800,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            if (_filteredAgregados.isNotEmpty) ...[
                              _buildSectionHeader('Mis enfermedades'),
                              ..._filteredAgregados
                                  .map((p) => _EnfermedadTile(enfermedad: p)),
                            ],
                            if (_filteredCompartidos.isNotEmpty) ...[
                              _buildSectionHeader('Compartidas'),
                              ..._filteredCompartidos
                                  .map((p) => _EnfermedadTile(enfermedad: p)),
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
                              ..._filteredCatalogo
                                  .map((p) => _EnfermedadTile(enfermedad: p)),
                            ],
                            if (_filteredCatalogo.isEmpty &&
                                _filteredAgregados.isEmpty &&
                                _filteredCompartidos.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                      'No se encontraron enfermedades'),
                                ),
                              ),
                            const CopyrightFooter(),
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

class _EnfermedadTile extends StatelessWidget {
  final Enfermedad enfermedad;
  const _EnfermedadTile({required this.enfermedad});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white.withOpacity(0.82),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
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
        title: Text(
          enfermedad.nombre,
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.greenDarker),
        ),
        subtitle: Text(
          enfermedad.tipo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EnfermedadDetallePage(enfermedad: enfermedad),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (enfermedad.imagePath != null && enfermedad.imagePath!.isNotEmpty) {
      if (enfermedad.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(enfermedad.imagePath!.split(',').last),
          fit: BoxFit.cover,
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            enfermedad.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(enfermedad.imagePath!),
            fit: BoxFit.cover,
          );
        }
      }
    }
    if (enfermedad.imagen.isNotEmpty) {
      return Image.asset(
        enfermedad.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.biotech_rounded),
      );
    }
    return const Icon(Icons.biotech_rounded, color: AppColors.greenDarker);
  }
}