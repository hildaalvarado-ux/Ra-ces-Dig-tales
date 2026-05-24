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
import 'pesticida_detalle.dart';
import 'pesticida_form.dart';

class PesticidasPage extends StatefulWidget {
  final int userId;
  const PesticidasPage({super.key, required this.userId});

  @override
  State<PesticidasPage> createState() => _PesticidasPageState();
}

class _PesticidasPageState extends State<PesticidasPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;

  final List<Pesticida> _catalogo = [];
  final List<Pesticida> _agregados = [];
  final List<Pesticida> _compartidos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _loading = true);
    try {
      await _loadCatalog();
      await _loadUserPesticidas();
      await _loadSharedPesticidas();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCatalog() async {
    final list = await catalogManager.getPesticides();
    _catalogo
      ..clear()
      ..addAll(list);
  }

  Future<void> _loadUserPesticidas() async {
    final list = await appDb.getUserPesticidas(widget.userId);
    _agregados.clear();

    for (final row in list) {
      final data = jsonDecode(row.payloadJson);
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _agregados.add(Pesticida.fromJson(data));
    }
  }

  Future<void> _loadSharedPesticidas() async {
    final list = await appDb.getSharedPesticidas(widget.userId);
    _compartidos.clear();

    for (final row in list) {
      final data = jsonDecode(row.payloadJson);
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _compartidos.add(Pesticida.fromJson(data));
    }
  }

  List<Pesticida> _applyFilters(List<Pesticida> list) {
    final q = _searchCtrl.text.toLowerCase();
    return list.where((p) =>
        p.nombre.toLowerCase().contains(q) ||
        p.tipo.toLowerCase().contains(q)).toList();
  }

  Future<void> _abrirFormulario({Pesticida? pesticida}) async {
    final res = await Navigator.push<Pesticida>(
      context,
      MaterialPageRoute(builder: (_) => PesticidaFormPage(pesticida: pesticida)),
    );

    if (res == null) return;

    if (pesticida == null) {
      await appDb.insertUserPesticida(
        userId: widget.userId,
        nombre: res.nombre,
        tipo: res.tipo,
        imagePath: res.imagePath,
        payloadJson: jsonEncode(res.toJson()),
      );
    } else {
      await appDb.updateUserPesticida(
        id: pesticida.id!,
        nombre: res.nombre,
        tipo: res.tipo,
        imagePath: res.imagePath,
        payloadJson: jsonEncode(res.toJson()),
      );
    }
    await _loadUserPesticidas();
  }

  Future<void> _eliminar(Pesticida p, {bool shared = false}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar repelente'),
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
      await appDb.deleteSharedPesticida(p.id!);
      await _loadSharedPesticidas();
    } else {
      await appDb.deleteUserPesticida(p.id!);
      await _loadUserPesticidas();
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
      final temp = Pesticida.fromJson(data);

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
            'pesticidas_images',
            ext,
          );
        }
      }

      await appDb.insertSharedPesticida(
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
    final catalogo = _applyFilters(_catalogo);
    final agregados = _applyFilters(_agregados);
    final compartidos = _applyFilters(_compartidos);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Repelentes', style: TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'Nuevo repelente',
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar repelente...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
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
                          if (agregados.isNotEmpty) ...[
                            _buildSectionHeader('Mis Repelentes'),
                            ...agregados.map((p) => _tile(p, onEdit: () => _abrirFormulario(pesticida: p), onDelete: () => _eliminar(p))),
                          ],
                          if (compartidos.isNotEmpty) ...[
                            _buildSectionHeader('Compartidos'),
                            ...compartidos.map((p) => _tile(p, onDelete: () => _eliminar(p, shared: true))),
                          ],
                          if (catalogo.isNotEmpty) ...[
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
                            ...catalogo.map((p) => _tile(p)),
                          ],
                          if (catalogo.isEmpty &&
                              agregados.isEmpty &&
                              compartidos.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'No se encontraron repelentes.',
                                ),
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
    );
  }

  Widget _buildSectionHeader(String title, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (action != null) action,
        ],
      ),
    );
  }

  Widget _tile(Pesticida p, {VoidCallback? onEdit, VoidCallback? onDelete}) => Card(
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
              child: _buildTileImage(p),
            ),
          ),
          title: Text(
            p.nombre,
            style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker),
          ),
          subtitle: Text(p.tipo),
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
              builder: (_) => PesticidaDetallePage(pesticida: p),
            ),
            ),
        ),
      );

  Widget _buildTileImage(Pesticida p) {
    if (p.imagePath != null && p.imagePath!.isNotEmpty) {
      if (p.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(p.imagePath!.split(',').last),
          fit: BoxFit.cover,
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            p.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.file(
            File(p.imagePath!),
            fit: BoxFit.cover,
          );
        }
      }
    }
    if (p.imagen.isNotEmpty) {
      return Image.asset(
        p.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded),
      );
    }
    return const Icon(Icons.sanitizer_rounded, color: AppColors.greenDarker);
  }
}
