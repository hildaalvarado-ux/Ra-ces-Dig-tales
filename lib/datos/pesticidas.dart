import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/db_instance.dart';
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
      debugPrint('Error loading pesticides: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCatalog() async {
    final raw = await rootBundle.loadString('assets/data/pesticidas.json');
    final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
    final decoded = jsonDecode(cleanJson) as List;
    _catalogo.clear();
    _catalogo.addAll(decoded.map((e) => Pesticida.fromJson(Map<String, dynamic>.from(e))));
  }

  Future<void> _loadUserPesticidas() async {
    final list = await appDb.getUserPesticidas(widget.userId);
    _agregados.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _agregados.add(Pesticida.fromJson(data));
    }
  }

  Future<void> _loadSharedPesticidas() async {
    final list = await appDb.getSharedPesticidas(widget.userId);
    _compartidos.clear();
    for (final row in list) {
      final data = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      data['id'] = row.id;
      data['imagePath'] = row.imagePath;
      _compartidos.add(Pesticida.fromJson(data));
    }
  }

  List<Pesticida> _applyFilters(List<Pesticida> list) {
    final q = _searchCtrl.text.toLowerCase();
    return list.where((p) => p.nombre.toLowerCase().contains(q) || p.tipo.toLowerCase().contains(q)).toList();
  }

  List<Pesticida> get _filteredCatalogo => _applyFilters(_catalogo);
  List<Pesticida> get _filteredAgregados => _applyFilters(_agregados);
  List<Pesticida> get _filteredCompartidos => _applyFilters(_compartidos);

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Pesticidas', style: TextStyle(fontWeight: FontWeight.w900)),
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
                    hintText: 'Buscar pesticida...',
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
                              _buildSectionHeader('Mis pesticidas'),
                              ..._filteredAgregados.map((p) => _PesticidaTile(pesticida: p)),
                            ],
                            if (_filteredCompartidos.isNotEmpty) ...[
                              _buildSectionHeader('Compartidos'),
                              ..._filteredCompartidos.map((p) => _PesticidaTile(pesticida: p)),
                            ],
                            if (_filteredCatalogo.isNotEmpty) ...[
                              _buildSectionHeader('Catálogo'),
                              ..._filteredCatalogo.map((p) => _PesticidaTile(pesticida: p)),
                            ],
                            if (_filteredCatalogo.isEmpty && _filteredAgregados.isEmpty && _filteredCompartidos.isEmpty)
                              const Center(child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No se encontraron pesticidas'),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: AppColors.greenDarker.withOpacity(0.6), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.2),
      ),
    );
  }
}

class _PesticidaTile extends StatelessWidget {
  final Pesticida pesticida;
  const _PesticidaTile({required this.pesticida});

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
        title: Text(pesticida.nombre, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
        subtitle: Text(pesticida.tipo),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PesticidaDetallePage(pesticida: pesticida))),
      ),
    );
  }

  Widget _buildImage() {
    if (pesticida.imagePath != null && pesticida.imagePath!.isNotEmpty) {
      if (pesticida.imagePath!.startsWith('data:image')) {
        return Image.memory(base64Decode(pesticida.imagePath!.split(',').last), fit: BoxFit.cover);
      } else {
        return Image.file(File(pesticida.imagePath!), fit: BoxFit.cover);
      }
    }
    if (pesticida.imagen.isNotEmpty) {
      return Image.asset(pesticida.imagen, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer_rounded));
    }
    return const Icon(Icons.sanitizer_rounded, color: AppColors.greenDarker);
  }
}
