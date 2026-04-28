import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/db_instance.dart';
import '../data/catalog_manager.dart';
import '../main.dart';
import 'pesticida_detalle.dart';

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
                            _header('Mis Repelentes'),
                            ...agregados.map((p) => _tile(p)),
                          ],
                          if (compartidos.isNotEmpty) ...[
                            _header('Compartidos'),
                            ...compartidos.map((p) => _tile(p)),
                          ],
                          if (catalogo.isNotEmpty) ...[
                            _header('Catálogo'),
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
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _tile(Pesticida p) => Card(
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
}