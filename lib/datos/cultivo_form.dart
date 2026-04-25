import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/image_utils.dart';
import '../main.dart';
import 'cultivo_detalle.dart';

class CultivoFormPage extends StatefulWidget {
  final Cultivo? cultivo;
  const CultivoFormPage({super.key, this.cultivo});

  @override
  State<CultivoFormPage> createState() => _CultivoFormPageState();
}

class _CultivoFormPageState extends State<CultivoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _cientificoCtrl;
  late TextEditingController _cosechaMesesCtrl;
  late TextEditingController _identificacionCtrl;
  late TextEditingController _siembraCtrl;

  // Almácigo settings
  bool _usaAlmacigo = false;
  late TextEditingController _tiempoAlmacigoCtrl;

  String _tipo = 'Vegetal';
  String _estacion = 'Todas';
  String? _imagePath;

  final Map<String, TextEditingController> _fichaCtrls = {};
  final List<String> _fichaKeys = [];
  final List<TextEditingController> _plagasCtrls = [];

  final List<String> _defaultFichaKeys = [
    'Temporada de siembra',
    'Época de siembra',
    'Tipo de siembra',
    'Profundidad de semilla',
    'Distancia entre plantas',
    'Fase lunar',
    'Clima ideal',
    'Resistencia al frío',
    'Temperatura mínima',
    'Temperatura máxima',
    'Riego',
    'Luz solar',
    'Cosecha en',
    'Temporada de cosecha',
    'Época de cosecha',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.cultivo;

    _nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    _cientificoCtrl = TextEditingController(text: c?.cientifico ?? '');
    _cosechaMesesCtrl = TextEditingController(text: c?.cosechaMeses.toString() ?? '0');
    _identificacionCtrl = TextEditingController(text: c?.identificacion ?? '');
    _siembraCtrl = TextEditingController(text: c?.siembra ?? '');

    final guia = c?.guiaRapida ?? {};
    _usaAlmacigo = guia['usaAlmacigo'] == true;
    _tiempoAlmacigoCtrl = TextEditingController(text: (guia['tiempoAlmacigo'] ?? 0).toString());

    if (c != null) {
      _tipo = c.tipo;
      _estacion = c.estacion;
      _imagePath = c.imagePath;

      // Unir llaves por defecto con las existentes en el cultivo
      final allKeys = {..._defaultFichaKeys, ...c.ficha.keys};
      for (var key in allKeys) {
        _fichaKeys.add(key);
        _fichaCtrls[key] = TextEditingController(text: c.ficha[key] ?? '');
      }

      for (var p in c.plagas) {
        _plagasCtrls.add(TextEditingController(text: p));
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
    _cosechaMesesCtrl.dispose();
    _identificacionCtrl.dispose();
    _siembraCtrl.dispose();
    _tiempoAlmacigoCtrl.dispose();
    for (var ctrl in _fichaCtrls.values) {
      ctrl.dispose();
    }
    for (var ctrl in _plagasCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _addPlaga() {
    setState(() {
      _plagasCtrls.add(TextEditingController());
    });
  }

  void _removePlaga(int index) {
    setState(() {
      _plagasCtrls[index].dispose();
      _plagasCtrls.removeAt(index);
    });
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
            labelText: 'Nombre del campo (ej: pH del suelo)',
            hintText: 'Ingrese el nombre de la información adicional',
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
                  final path = await ImageUtils.pickAndSaveImage('cultivos_images', source: ImageSource.camera);
                  if (path != null) setState(() => _imagePath = path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.greenDark),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await ImageUtils.pickAndSaveImage('cultivos_images', source: ImageSource.gallery);
                  if (path != null) setState(() => _imagePath = path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_rounded, color: AppColors.greenDark),
                title: const Text('Archivos'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await ImageUtils.pickAndSaveImageFromFiles('cultivos_images');
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

    final guia = Map<String, dynamic>.from(widget.cultivo?.guiaRapida ?? {});
    guia['usaAlmacigo'] = _usaAlmacigo;
    guia['tiempoAlmacigo'] = int.tryParse(_tiempoAlmacigoCtrl.text.trim()) ?? 0;

    final nuevo = Cultivo(
      id: widget.cultivo?.id,
      nombre: _nombreCtrl.text.trim(),
      cientifico: _cientificoCtrl.text.trim(),
      imagen: widget.cultivo?.imagen ?? '',
      imagePath: _imagePath,
      cosechaMeses: int.tryParse(_cosechaMesesCtrl.text.trim()) ?? 0,
      tipo: _tipo,
      estacion: _estacion,
      identificacion: _identificacionCtrl.text.trim(),
      siembra: _siembraCtrl.text.trim(),
      ficha: _fichaCtrls.map((k, v) => MapEntry(k, v.text.trim())),
      plagas: _plagasCtrls.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
      guiaRapida: guia,
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
          title: Text(widget.cultivo == null ? 'Nuevo Cultivo' : 'Editar Cultivo',
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

                // ✅ Imagen del cultivo
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
                _buildTextField(_cosechaMesesCtrl, 'Meses hasta cosecha', isNumber: true),

                const SizedBox(height: 10),
                _buildDropdown('Tipo', _tipo,
                  ['Raíz', 'Hoja', 'Frutal', 'Legumbre', 'Aromáticas', 'Vegetal'],
                  (v) => setState(() => _tipo = v!)),

                _buildDropdown('Estación', _estacion,
                  ['Todas', 'Otoño', 'Invierno', 'Primavera', 'Verano'],
                  (v) => setState(() => _estacion = v!)),

                const SizedBox(height: 20),
                _buildSectionTitle('Configuración de Almácigo'),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('¿Requiere almácigo?', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Activa esta opción si el cultivo se inicia en semillero antes de trasplantar.'),
                        value: _usaAlmacigo,
                        activeColor: AppColors.greenDark,
                        onChanged: (v) => setState(() => _usaAlmacigo = v),
                      ),
                      if (_usaAlmacigo)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: _buildTextField(_tiempoAlmacigoCtrl, 'Días en almácigo hasta trasplante', isNumber: true),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                _buildSectionTitle('Detalles'),
                _buildTextField(_identificacionCtrl, 'Identificación', maxLines: 3),
                _buildTextField(_siembraCtrl, 'Instrucciones de Siembra', maxLines: 3),

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

                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSectionTitle('Insectos'),
                    const Spacer(),
                    IconButton(
                      onPressed: _addPlaga,
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.greenDark),
                    ),
                  ],
                ),
                ...List.generate(_plagasCtrls.length, (index) {
                  return Row(
                    children: [
                      Expanded(child: _buildTextField(_plagasCtrls[index], 'Insecto ${index + 1}')),
                      IconButton(
                        onPressed: () => _removePlaga(index),
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      ),
                    ],
                  );
                }),
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
      {bool required = false, bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
