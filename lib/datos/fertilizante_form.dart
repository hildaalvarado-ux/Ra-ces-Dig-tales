import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/image_utils.dart';
import '../data/common_widgets.dart';
import '../data/catalog_manager.dart';
import '../main.dart';
import 'fertilizante_detalle.dart';

class FertilizanteFormPage extends StatefulWidget {
  final Fertilizante? fertilizante;
  const FertilizanteFormPage({super.key, this.fertilizante});

  @override
  State<FertilizanteFormPage> createState() => _FertilizanteFormPageState();
}

class _FertilizanteFormPageState extends State<FertilizanteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _identificacionCtrl;
  late TextEditingController _usoCtrl;
  late TextEditingController _faseAplicacionCtrl;
  late TextEditingController _dificultadCtrl;

  String _tipo = 'Orgánico';
  bool _esCasero = false;
  String? _imagePath;

  final Map<String, TextEditingController> _fichaCtrls = {};
  final List<String> _fichaKeys = [];

  final List<TextEditingController> _ingredientesCtrls = [];
  final List<TextEditingController> _elaboracionCtrls = [];
  final List<TextEditingController> _precaucionesCtrls = [];

  List<String> _plagasOptions = [];
  List<String> _selectedPlagas = [];

  @override
  void initState() {
    super.initState();
    _loadOptions();
    final f = widget.fertilizante;

    _nombreCtrl = TextEditingController(text: f?.nombre ?? '');
    _identificacionCtrl = TextEditingController(text: f?.identificacion ?? '');
    _usoCtrl = TextEditingController(text: f?.uso ?? '');
    _faseAplicacionCtrl = TextEditingController(text: f?.faseAplicacion ?? '');
    _dificultadCtrl = TextEditingController(text: f?.dificultad ?? '');

    if (f != null) {
      _tipo = f.tipo;
      _esCasero = f.esCasero;
      _imagePath = f.imagePath;
      _selectedPlagas = List.from(f.plagas);

      for (var key in f.ficha.keys) {
        _fichaKeys.add(key);
        _fichaCtrls[key] = TextEditingController(text: f.ficha[key]);
      }

      for (var item in f.ingredientes) {
        _ingredientesCtrls.add(TextEditingController(text: item));
      }
      for (var item in f.elaboracion) {
        _elaboracionCtrls.add(TextEditingController(text: item));
      }
      for (var item in f.precauciones) {
        _precaucionesCtrls.add(TextEditingController(text: item));
      }
    } else {
      _fichaKeys.addAll(['Frecuencia', 'Dosis', 'Época']);
      for (var k in _fichaKeys) {
        _fichaCtrls[k] = TextEditingController();
      }
    }
  }

  Future<void> _loadOptions() async {
    final pests = await catalogManager.getPests();
    setState(() {
      _plagasOptions = pests.map((p) => p.nombre).toList();
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _identificacionCtrl.dispose();
    _usoCtrl.dispose();
    _faseAplicacionCtrl.dispose();
    _dificultadCtrl.dispose();
    for (var c in _fichaCtrls.values) {
      c.dispose();
    }
    for (var c in _ingredientesCtrls) {
      c.dispose();
    }
    for (var c in _elaboracionCtrls) {
      c.dispose();
    }
    for (var c in _precaucionesCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addItem(List<TextEditingController> list) {
    setState(() => list.add(TextEditingController()));
  }

  void _removeItem(List<TextEditingController> list, int index) {
    setState(() {
      list[index].dispose();
      list.removeAt(index);
    });
  }

  void _addFichaField() {
    final keyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo campo'),
        content: TextField(controller: keyCtrl, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () {
              final k = keyCtrl.text.trim();
              if (k.isNotEmpty && !_fichaKeys.contains(k)) {
                setState(() {
                  _fichaKeys.add(k);
                  _fichaCtrls[k] = TextEditingController();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('AGREGAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final path = await ImageUtils.pickAndSaveImage('fertilizantes_images');
    if (path != null) setState(() => _imagePath = path);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final nuevo = Fertilizante(
      id: widget.fertilizante?.id,
      nombre: _nombreCtrl.text.trim(),
      imagen: widget.fertilizante?.imagen ?? '',
      imagePath: _imagePath,
      tipo: _tipo,
      identificacion: _identificacionCtrl.text.trim(),
      uso: _usoCtrl.text.trim(),
      ficha: _fichaCtrls.map((k, v) => MapEntry(k, v.text.trim())),
      ingredientes: _ingredientesCtrls.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
      elaboracion: _elaboracionCtrls.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
      precauciones: _precaucionesCtrls.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
      esCasero: _esCasero,
      dificultad: _dificultadCtrl.text.trim(),
      faseAplicacion: _faseAplicacionCtrl.text.trim(),
      plagas: _selectedPlagas,
    );

    Navigator.pop(context, nuevo);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(widget.fertilizante == null ? 'Nuevo Fertilizante' : 'Editar Fertilizante'),
          actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle('Básico'),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _imagePath!.startsWith('data:image')
                                ? Image.memory(base64Decode(_imagePath!.split(',').last), fit: BoxFit.cover)
                                : Image.file(File(_imagePath!), fit: BoxFit.cover),
                          )
                        : const Icon(Icons.add_a_photo, size: 40, color: AppColors.greenSoft),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_nombreCtrl, 'Nombre', required: true),
              _buildDropdown('Tipo', _tipo, ['Orgánico', 'Químico', 'Mineral', 'Bioestimulante'], (v) => setState(() => _tipo = v!)),
              SwitchListTile(
                title: const Text('Es de elaboración casera', style: TextStyle(fontWeight: FontWeight.bold)),
                value: _esCasero,
                onChanged: (v) => setState(() => _esCasero = v),
              ),
              _buildTextField(_identificacionCtrl, 'Descripción / Identificación', maxLines: 3),
              _buildTextField(_usoCtrl, 'Modo de uso', maxLines: 3),
              _buildTextField(_faseAplicacionCtrl, 'Fase de aplicación (ej: Crecimiento)'),
              if (_esCasero) _buildTextField(_dificultadCtrl, 'Dificultad (ej: Fácil)'),

              const SizedBox(height: 20),
              SearchableMultiSelect(
                title: 'Insectos que combate o repele',
                options: _plagasOptions,
                initialSelected: _selectedPlagas,
                onSelected: (list) => _selectedPlagas = list,
              ),

              const SizedBox(height: 20),
              _buildListSection('Ingredientes', _ingredientesCtrls),
              const SizedBox(height: 20),
              _buildListSection('Pasos de Elaboración', _elaboracionCtrls),
              const SizedBox(height: 20),
              _buildListSection('Precauciones', _precaucionesCtrls),

              const SizedBox(height: 20),
              Row(
                children: [
                  _buildSectionTitle('Ficha Rápida'),
                  const Spacer(),
                  IconButton(onPressed: _addFichaField, icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              ..._fichaKeys.map((k) => Row(children: [
                Expanded(child: _buildTextField(_fichaCtrls[k]!, k)),
                IconButton(onPressed: () => setState(() {
                  _fichaKeys.remove(k);
                  _fichaCtrls[k]?.dispose();
                  _fichaCtrls.remove(k);
                }), icon: const Icon(Icons.remove_circle_outline, color: Colors.red)),
              ])),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDarker)),
  );

  Widget _buildTextField(TextEditingController c, String l, {bool required = false, int maxLines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: l, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white.withOpacity(0.8)),
      validator: required ? (v) => v == null || v.isEmpty ? 'Requerido' : null : null,
    ),
  );

  Widget _buildDropdown(String l, String v, List<String> items, ValueChanged<String?> onChanged) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: v,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: l, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white.withOpacity(0.8)),
    ),
  );

  Widget _buildListSection(String title, List<TextEditingController> list) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          _buildSectionTitle(title),
          const Spacer(),
          IconButton(onPressed: () => _addItem(list), icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      ...List.generate(list.length, (i) => Row(children: [
        Expanded(child: _buildTextField(list[i], '$title ${i + 1}')),
        IconButton(onPressed: () => _removeItem(list, i), icon: const Icon(Icons.remove_circle_outline, color: Colors.red)),
      ])),
    ],
  );
}
