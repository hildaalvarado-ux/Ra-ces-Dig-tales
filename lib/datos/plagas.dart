import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/db_instance.dart';
import '../data/catalog_manager.dart';
import '../main.dart';
import 'plaga_detalle.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text(
            'Insectos', // ✅ CAMBIADO
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
                    hintText: 'Buscar insecto...', // ✅ CAMBIADO
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
                              _buildSectionHeader('Mis insectos'), // ✅
                              ..._filteredAgregados
                                  .map((p) => _PlagaTile(plaga: p)),
                            ],
                            if (_filteredCompartidos.isNotEmpty) ...[
                              _buildSectionHeader('Compartidos'),
                              ..._filteredCompartidos
                                  .map((p) => _PlagaTile(plaga: p)),
                            ],
                            if (_filteredCatalogo.isNotEmpty) ...[
                              _buildSectionHeader('Catálogo'),
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
                                      'No se encontraron insectos'), // ✅
                                ),
                              ),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.greenDarker.withOpacity(0.6),
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _PlagaTile extends StatelessWidget {
  final Plaga plaga;
  const _PlagaTile({required this.plaga});

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