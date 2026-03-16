import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/db_instance.dart';
import '../data/image_utils.dart';
import '../main.dart';
import 'cultivo_detalle.dart';
import 'cultivo_form.dart';

class CultivosPage extends StatefulWidget {
  final int userId;
  const CultivosPage({super.key, required this.userId});

  @override
  State<CultivosPage> createState() => _CultivosPageState();
}

class _CultivosPageState extends State<CultivosPage> {
  final _searchCtrl = TextEditingController();

  String _orden = 'Nombre';
  String _filtroCosecha = 'Todas';
  String _filtroTipo = 'Todos';
  String _filtroEstacion = 'Todas';

  bool _loading = true;

  /// Cultivos predeterminados desde assets/data/cultivos.json
  final List<Cultivo> _catalogo = [];

  /// Cultivos creados/importados por el usuario
  /// Cultivos creados por el usuario
  final List<Cultivo> _agregados = [];

  /// Cultivos compartidos (importados)
  final List<Cultivo> _compartidos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() => _loading = true);
    }

    try {
      await _loadCatalogFromAssets();
      await _loadUserCultivos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando datos: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadCatalogFromAssets() async {
    final raw = await rootBundle.loadString('assets/data/cultivos.json');
    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw Exception('El archivo cultivos.json no contiene una lista válida');
    }

    final list = decoded.cast<dynamic>();

    _catalogo
      ..clear()
      ..addAll(
        list.map((e) => Cultivo.fromJson(Map<String, dynamic>.from(e))),
      );
  }

  Future<void> _loadUserCultivos() async {
    final list = await appDb.getUserCultivos(widget.userId);

    _agregados.clear();

    for (final row in list) {
      final data = jsonDecode(row.data) as Map<String, dynamic>;
      data['id'] = row.id;
      _agregados.add(Cultivo.fromJson(data));
    }
  }

  List<Cultivo> get _all => [..._catalogo, ..._agregados];

  List<Cultivo> get _filtered {
    }
  }

  List<Cultivo> _applyFilters(List<Cultivo> original) {
    final q = _searchCtrl.text.trim().toLowerCase();

    var list = original.where((c) {
      final matchesText = q.isEmpty ||
          c.nombre.toLowerCase().contains(q) ||
          c.cientifico.toLowerCase().contains(q);

      final matchesCosecha = _filtroCosecha == 'Todas' ||
          (_filtroCosecha == '1-3' && c.cosechaMeses <= 3) ||
          (_filtroCosecha == '4-6' &&
              c.cosechaMeses >= 4 &&
              c.cosechaMeses <= 6) ||
          (_filtroCosecha == '7+' && c.cosechaMeses >= 7);

      final matchesTipo = _filtroTipo == 'Todos' || c.tipo == _filtroTipo;
      final matchesEstacion =
          _filtroEstacion == 'Todas' || c.estacion == _filtroEstacion;

      return matchesText &&
          matchesCosecha &&
          matchesTipo &&
          matchesEstacion;
    }).toList();

    if (_orden == 'Nombre') {
      list.sort((a, b) => a.nombre.compareTo(b.nombre));
    } else if (_orden == 'Cosecha') {
      list.sort((a, b) => a.cosechaMeses.compareTo(b.cosechaMeses));
    } else if (_orden == 'Tipo') {
      list.sort((a, b) => a.tipo.compareTo(b.tipo));
    } else if (_orden == 'Estación') {
      list.sort((a, b) => a.estacion.compareTo(b.estacion));
    }

    return list;
  }

  Future<void> _importFromJsonPaste() async {
    final ctrl = TextEditingController();

    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Importar cultivo'),
            content: TextField(
              controller: ctrl,
              minLines: 6,
              maxLines: 12,
              decoration: const InputDecoration(
                hintText: 'Pega aquí el JSON que te enviaron por WhatsApp',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenDarker,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Importar'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    try {
      final obj = jsonDecode(ctrl.text.trim());
      final cultivo = Cultivo.fromJson(obj as Map<String, dynamic>);

      await appDb.insertUserCultivo(
        widget.userId,
        jsonEncode(cultivo.toJson()),
      );

      await _loadData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Importado correctamente: ${tempCultivo.nombre}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar: $e')),
      );
    }
  }

  Future<void> _abrirFormulario({Cultivo? cultivo}) async {
    final res = await Navigator.of(context).push<Cultivo>(
      MaterialPageRoute(
        builder: (_) => CultivoFormPage(cultivo: cultivo),
      ),
    );

    if (res == null) return;

    if (cultivo == null) {
      await appDb.insertUserCultivo(
        userId: widget.userId,
        nombre: res.nombre,
        tipo: res.tipo,
        cosechaMeses: res.cosechaMeses,
        estacion: res.estacion,
        imagePath: res.imagePath,
        payloadJson: jsonEncode(res.toJson()),
      );
    } else {
      await appDb.updateUserCultivo(
        id: cultivo.id!,
        nombre: res.nombre,
        tipo: res.tipo,
        cosechaMeses: res.cosechaMeses,
        estacion: res.estacion,
        imagePath: res.imagePath,
        payloadJson: jsonEncode(res.toJson()),
      );
    }

    await _loadData();
  }

  Future<void> _eliminarCultivo(Cultivo c, {bool shared = false}) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Eliminar cultivo'),
            content: Text('¿Quieres eliminar "${c.nombre}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    await appDb.deleteUserCultivo(c.id!);
    await _loadData();
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
            'Cultivos',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: [
            IconButton(
              tooltip: 'Nuevo cultivo',
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add_rounded),
            ),
            IconButton(
              tooltip: 'Importar cultivo (.rdc)',
              onPressed: _importFromFile,
              icon: const Icon(Icons.download_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Nombre común o científico',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.85),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      tooltip: 'Limpiar',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {});
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.greenDark.withOpacity(0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.greenDark.withOpacity(0.15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Drop(
                      value: _orden,
                      items: const ['Nombre', 'Cosecha', 'Tipo', 'Estación'],
                      onChanged: (v) => setState(() => _orden = v),
                    ),
                    _Drop(
                      value: _filtroCosecha,
                      items: const ['Todas', '1-3', '4-6', '7+'],
                      onChanged: (v) => setState(() => _filtroCosecha = v),
                    ),
                    _Drop(
                      value: _filtroTipo,
                      items: const [
                        'Todos',
                        'Raíz',
                        'Hoja',
                        'Frutal',
                        'Legumbre',
                        'Aromáticas',
                        'Vegetal'
                      ],
                      onChanged: (v) => setState(() => _filtroTipo = v),
                    ),
                    _Drop(
                      value: _filtroEstacion,
                      items: const [
                        'Todas',
                        'Otoño',
                        'Invierno',
                        'Primavera',
                        'Verano'
                      ],
                      onChanged: (v) => setState(() => _filtroEstacion = v),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _filtered.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay cultivos para mostrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final c = _filtered[index];
                                return _CultivoTile(
                                  cultivo: c,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CultivoDetallePage(cultivo: c),
                                    ),
                                  ),
                                  onEdit: c.id != null
                                      ? () => _abrirFormulario(cultivo: c)
                                      : null,
                                  onDelete: c.id != null
                                      ? () => _eliminarCultivo(c)
                                      : null,
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

class _Drop extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _Drop({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.greenDark.withOpacity(0.14),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _CultivoTile extends StatelessWidget {
  final Cultivo cultivo;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CultivoTile({
    required this.cultivo,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  IconData _tipoIcon(String tipo) {
    switch (tipo) {
      case 'Raíz':
        return Icons.spa_rounded;
      case 'Hoja':
        return Icons.eco_rounded;
      case 'Frutal':
        return Icons.local_florist_rounded;
      case 'Legumbre':
        return Icons.grass_rounded;
      case 'Aromáticas':
        return Icons.local_florist_rounded;
      default:
        return Icons.nature_rounded;
    }
  }

  IconData _estacionIcon(String estacion) {
    switch (estacion) {
      case 'Otoño':
        return Icons.park_rounded;
      case 'Invierno':
        return Icons.ac_unit_rounded;
      case 'Primavera':
        return Icons.wb_sunny_rounded;
      case 'Verano':
        return Icons.wb_sunny_rounded;
      default:
        return Icons.calendar_month_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.82),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.greenDark.withOpacity(0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.greenDark.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.greenDark.withOpacity(0.12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _buildImage(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cultivo.nombre,
                      style: const TextStyle(
                        color: AppColors.greenDarker,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cultivo.cosechaMeses > 0
                          ? '${cultivo.cosechaMeses} meses'
                          : 'Sin dato',
                      style: TextStyle(
                        color: AppColors.greenDarker.withOpacity(0.70),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(_tipoIcon(cultivo.tipo), color: AppColors.greenDarker),
              const SizedBox(width: 10),
              Icon(_estacionIcon(cultivo.estacion),
                  color: AppColors.greenDarker),
              if (onEdit != null || onDelete != null) ...[
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') onEdit?.call();
                    if (v == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.greenDarker,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (cultivo.imagePath != null && cultivo.imagePath!.isNotEmpty) {
      if (cultivo.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(cultivo.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        return Image.file(
          File(cultivo.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      }
    }

    if (cultivo.imagen.isNotEmpty) {
      return Image.asset(
        cultivo.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.local_florist_rounded),
      );
    }

    return const Icon(
      Icons.local_florist_rounded,
      color: AppColors.greenDarker,
    );
  }
}
