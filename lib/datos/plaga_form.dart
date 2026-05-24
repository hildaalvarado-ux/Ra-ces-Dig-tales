import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/image_utils.dart';
import '../main.dart';
import 'plaga_detalle.dart';

class PlagaFormPage extends StatefulWidget {
  final Plaga? plaga;
  const PlagaFormPage({super.key, this.plaga});

  @override
  State<PlagaFormPage> createState() => _PlagaFormPageState();
}

class _PlagaFormPageState extends State<PlagaFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _cientificoCtrl;
  late TextEditingController _descripcionCtrl;
  late TextEditingController _identificacionCtrl;
  late TextEditingController _sintomasCtrl;
  late TextEditingController _danosCtrl;
  late TextEditingController _causasCtrl;
  late TextEditingController _controlCtrl;

  String? _imagePath;
  final Map<String, TextEditingController> _fichaCtrls = {};
  final List<String> _fichaKeys = [];

  final List<String> _defaultFichaKeys = [
    'Ciclo de vida',
    'Época de aparición',
    'Condiciones favorables',
    'Huéspedes principales',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.plaga;

    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _cientificoCtrl = TextEditingController(text: p?.cientifico ?? '');
    _descripcionCtrl = TextEditingController(text: p?.descripcion ?? '');
    _identificacionCtrl = TextEditingController(text: p?.identificacion ?? '');
    _sintomasCtrl = TextEditingController(text: p?.sintomas ?? '');
    _danosCtrl = TextEditingController(text: p?.danos ?? '');
    _causasCtrl = TextEditingController(text: p?.causas ?? '');
    _controlCtrl = TextEditingController(text: p?.control ?? '');

    if (p != null) {
      _imagePath = p.imagePath;
      final allKeys = {..._defaultFichaKeys, ...p.ficha.keys};
      for (var key in allKeys) {
        _fichaKeys.add(key);
        _fichaCtrls[key] = TextEditingController(text: p.ficha[key] ?? '');
      }
    } else {
      for (var key in _defaultFichaKeys) {
        _fichaKeys.add(key);
        _fichaCtrls[key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _cientificoCtrl.dispose();
    _descripcionCtrl.dispose();
    _identificacionCtrl.dispose();
    _sintomasCtrl.dispose();
    _danosCtrl.dispose();
    _causasCtrl.dispose();
    _controlCtrl.dispose();
    for (var ctrl in _fichaCtrls.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _addFichaField() {
    final keyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo campo personalizado'),
        content: TextField(
          controller: keyCtrl,
          decoration: const InputDecoration(
            labelText: 'Nombre del campo',
            hintText: 'Ej: Distribución geográfica',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () {
              final key = keyCtrl.text.trim();
              if (key.isNotEmpty && !_fichaKeys.contains(key)) {
                setState(() {
                  _fichaKeys.add(key);
                  _fichaCtrls[key] = TextEditingController();
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

  void _removeFichaField(String key) {
    setState(() {
      _fichaKeys.remove(key);
      _fichaCtrls[key]?.dispose();
      _fichaCtrls.remove(key);
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              const ListTile(
                title: Text('Seleccionar imagen',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.greenDark),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await ImageUtils.pickAndSaveImage('plagas_images', source: ImageSource.camera);
                  if (path != null) setState(() => _imagePath = path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.greenDark),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await ImageUtils.pickAndSaveImage('plagas_images', source: ImageSource.gallery);
                  if (path != null) setState(() => _imagePath = path);
                },
              ),
              if (_imagePath != null)
                ListTile(
                  leading: const Icon(Icons.delete_rounded, color: Colors.red),
                  title: const Text('Eliminar imagen', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _imagePath = null);
                  },
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final nuevo = Plaga(
      id: widget.plaga?.id,
      nombre: _nombreCtrl.text.trim(),
      cientifico: _cientificoCtrl.text.trim(),
      imagen: widget.plaga?.imagen ?? '',
      imagePath: _imagePath,
      imagenVisual: widget.plaga?.imagenVisual,
      descripcion: _descripcionCtrl.text.trim(),
      identificacion: _identificacionCtrl.text.trim(),
      sintomas: _sintomasCtrl.text.trim(),
      danos: _danosCtrl.text.trim(),
      causas: _causasCtrl.text.trim(),
      control: _controlCtrl.text.trim(),
      ficha: _fichaCtrls.map((k, v) => MapEntry(k, v.text.trim())),
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
          title: Text(widget.plaga == null ? 'Nuevo Insecto' : 'Editar Insecto',
              style: const TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              onPressed: _save,
              icon: const Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Información Básica'),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.greenDark.withOpacity(0.2)),
                      ),
                      child: _imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: _imagePath!.startsWith('data:image')
                                  ? Image.memory(
                                      base64Decode(_imagePath!.split(',').last),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_imagePath!),
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 40, color: AppColors.greenSoft),
                                SizedBox(height: 8),
                                Text('Elegir imagen',
                                    style: TextStyle(
                                      color: AppColors.greenSoft,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(_nombreCtrl, 'Nombre', required: true),
                _buildTextField(_cientificoCtrl, 'Nombre Científico'),
                _buildTextField(_descripcionCtrl, 'Descripción', maxLines: 3),
                const SizedBox(height: 20),
                _buildSectionTitle('Detalles de Campo'),
                _buildTextField(_identificacionCtrl, 'Identificación', maxLines: 3),
                _buildTextField(_sintomasCtrl, 'Síntomas', maxLines: 3),
                _buildTextField(_danosCtrl, 'Daños', maxLines: 3),
                _buildTextField(_causasCtrl, 'Causas de aparición', maxLines: 3),
                _buildTextField(_controlCtrl, 'Métodos de control', maxLines: 5),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSectionTitle('Ficha Técnica'),
                    const Spacer(),
                    IconButton(
                      onPressed: _addFichaField,
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.greenDark),
                      tooltip: 'Agregar campo personalizado',
                    ),
                  ],
                ),
                ..._fichaKeys.map((key) => Row(
                  children: [
                    Expanded(child: _buildTextField(_fichaCtrls[key]!, key)),
                    IconButton(
                      onPressed: () => _removeFichaField(key),
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      tooltip: 'Eliminar campo',
                    ),
                  ],
                )),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.greenDarker,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label,
      {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: required ? (v) => v == null || v.isEmpty ? 'Requerido' : null : null,
      ),
    );
  }
}
