import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final raw = await rootBundle.loadString('assets/data/plagas.json');
      final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
      final decoded = jsonDecode(cleanJson) as List;
      _catalogo.clear();
      _catalogo.addAll(decoded.map((e) => Plaga.fromJson(Map<String, dynamic>.from(e))));
    } catch (e) {
      debugPrint('Error loading pests: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Plaga> get _filtered => _catalogo.where((p) {
    final q = _searchCtrl.text.toLowerCase();
    return p.nombre.toLowerCase().contains(q) || p.cientifico.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Plagas', style: TextStyle(fontWeight: FontWeight.w900)),
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
                    hintText: 'Buscar plaga...',
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
                          ? const Center(child: Text('No se encontraron plagas'))
                          : ListView.builder(
                              itemCount: _filtered.length,
                              itemBuilder: (context, index) {
                                final p = _filtered[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  color: Colors.white.withOpacity(0.82),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: ListTile(
                                    leading: const Icon(Icons.bug_report_rounded, color: AppColors.greenDarker),
                                    title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
                                    subtitle: Text(p.cientifico, style: const TextStyle(fontStyle: FontStyle.italic)),
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlagaDetallePage(plaga: p))),
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
