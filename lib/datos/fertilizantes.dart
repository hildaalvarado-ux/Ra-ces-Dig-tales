import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final raw = await rootBundle.loadString('assets/data/fertilizantes.json');
      final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
      final decoded = jsonDecode(cleanJson) as List;
      _catalogo.clear();
      _catalogo.addAll(decoded.map((e) => Fertilizante.fromJson(Map<String, dynamic>.from(e))));
    } catch (e) {
      debugPrint('Error loading fertilizers: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Fertilizante> get _filtered => _catalogo.where((f) {
    final q = _searchCtrl.text.toLowerCase();
    return f.nombre.toLowerCase().contains(q) || f.tipo.toLowerCase().contains(q);
  }).toList();

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
                      : _filtered.isEmpty
                          ? const Center(child: Text('No se encontraron fertilizantes'))
                          : ListView.builder(
                              itemCount: _filtered.length,
                              itemBuilder: (context, index) {
                                final f = _filtered[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  color: Colors.white.withOpacity(0.82),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: ListTile(
                                    leading: const Icon(Icons.science_rounded, color: AppColors.greenDarker),
                                    title: Text(f.nombre, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
                                    subtitle: Text(f.tipo),
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FertilizanteDetallePage(fertilizante: f))),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
