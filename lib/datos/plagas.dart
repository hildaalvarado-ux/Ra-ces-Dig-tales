import '../data/common_widgets.dart';
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
import 'plaga_detalle.dart';
import 'plaga_form.dart';

class PlagasPage extends StatefulWidget {
  final int userId;
  const PlagasPage({super.key, required this.userId});

  @override
  State<PlagasPage> createState() => _PlagasPageState();
}

class _PlagasPageState extends State<PlagasPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;
  final List<Plaga> _catalogo = [];
  final List<Plaga> _agregados = [];
  final List<Plaga> _compartidos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _loading = true);
    try {
      await _loadCatalog();
      await _loadUserPlagas();
      await _loadSharedPlagas();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCatalog() async {
    final list = await catalogManager.getPests();
    _catalogo.clear();
    _catalogo.addAll(list);
  }

  Future<void> _loadUserPlagas() async {
    final list = await appDb.getUserPlagas(widget.userId);
    _agregados.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _agregados.add(Plaga.fromJson(data));
    }
  }

  Future<void> _loadSharedPlagas() async {
    final list = await appDb.getSharedPlagas(widget.userId);
    _compartidos.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _compartidos.add(Plaga.fromJson(data));
    }
  }

  List<Plaga> _applyFilters(List<Plaga> list) {
    final q = _searchCtrl.text.toLowerCase();
    return list.where((p) =>
        p.nombre.toLowerCase().contains(q) ||
        p.cientifico.toLowerCase().contains(q)).toList();
  }

  List<Plaga> get _filteredCatalogo => _applyFilters(_catalogo);
  List<Plaga> get _filteredAgregados => _applyFilters(_agregados);
  List<Plaga> get _filteredCompartidos => _applyFilters(_compartidos);

  Future<void> _abrirFormulario({Plaga? plaga}) async {
    final res = await Navigator.push<Plaga>(
      context,
      MaterialPageRoute(builder: (_) => PlagaFormPage(plaga: plaga)),
    );

    if (res == null) return;

    if (plaga == null) {
      await appDb.insertUserPlaga(
        userId: widget.userId,
        nombre: res.nombre,
        cientifico: res.cientifico,
        imagePath: res.imagePath,
        payloadJson: jsonEncode(res.toJson()),
      );
    } else {
      await appDb.updateUserPlaga(
        id: plaga.id!,
        nombre: res.nombre,
        cientifico: res.cientifico,
        imagePath: res.imagePath,
        payloadJson: jsonEncode(res.toJson()),
      );
    }
    await _loadUserPlagas();
  }

  Future<void> _eliminar(Plaga p, {bool shared = false}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar insecto'),
        content: Text('¿Quieres eliminar "${p.nombre}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ) ?? false;

    if (!ok) return;

    if (shared) {
      await appDb.deleteSharedPlaga(p.id!);
      await _loadSharedPlagas();
    } else {
      await appDb.deleteUserPlaga(p.id!);
      await _loadUserPlagas();
    }
  }

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
      final temp = Plaga.fromJson(data);

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
            'plagas_images',
            ext,
          );
        }
      }

      await appDb.insertSharedPlaga(
        userId: widget.userId,
        nombre: temp.nombre,
        cientifico: temp.cientifico,
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
            'Insectos',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: [
            IconButton(
              tooltip: 'Nuevo insecto',
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
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
                    hintText: 'Buscar insecto...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.85),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            if (_filteredAgregados.isNotEmpty) ...[
                              _buildSectionHeader('Mis insectos'),
                              ..._filteredAgregados
                                  .map((p) => _PlagaTile(
                                    plaga: p,
                                    onEdit: () => _abrirFormulario(plaga: p),
                                    onDelete: () => _eliminar(p),
                                  )),
                            ],
                            if (_filteredCompartidos.isNotEmpty) ...[
                              _buildSectionHeader('Compartidos'),
                              ..._filteredCompartidos
                                  .map((p) => _PlagaTile(
                                    plaga: p,
                                    onDelete: () => _eliminar(p, shared: true),
                                  )),
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
                                  .map((p) => _PlagaTile(plaga: p)),
                            ],
                            if (_filteredCatalogo.isEmpty &&
                                _filteredAgregados.isEmpty &&
                                _filteredCompartidos.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                      'No se encontraron insectos'),
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

class _PlagaTile extends StatelessWidget {
  final Plaga plaga;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _PlagaTile({required this.plaga, this.onEdit, this.onDelete});

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
          plaga.nombre,
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.greenDarker),
        ),
        subtitle: Text(
          plaga.cientifico,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        trailing: (onEdit != null || onDelete != null) ? PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') onEdit?.call();
            if (v == 'delete') onDelete?.call();
          },
          itemBuilder: (_) => [
            if (onEdit != null) const PopupMenuItem(value: 'edit', child: Text('Editar')),
            if (onDelete != null) const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ) : null,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlagaDetallePage(plaga: plaga),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (plaga.imagePath != null && plaga.imagePath!.isNotEmpty) {
      if (plaga.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(plaga.imagePath!.split(',').last),
          fit: BoxFit.cover,
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            plaga.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(plaga.imagePath!),
            fit: BoxFit.cover,
          );
        }
      }
    }
    if (plaga.imagen.isNotEmpty) {
      return Image.asset(
        plaga.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.bug_report_rounded),
      );
    }
    return const Icon(Icons.bug_report_rounded, color: AppColors.greenDarker);
  }
}
