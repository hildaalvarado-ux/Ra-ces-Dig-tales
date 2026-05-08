import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/file_management_service.dart';
import '../data/db_instance.dart';
import '../data/app_database.dart';
import '../data/soil_models.dart';
import 'preparacion_suelo.dart';
import '../main.dart';
import 'calendario.dart';
import 'help_dialogs.dart';
import 'plaga_detalle.dart';

class Cultivo {
  final int? id; // null si es del catálogo
  final String nombre;
  final String imagen; // ruta del asset
  final String? imagePath; // ruta del archivo local o base64 (web)
  final String cientifico;
  final int cosechaMeses;
  final String tipo;
  final String estacion;
  final String identificacion;
  final String siembra;
  final Map<String, String> ficha;
  final List<String> plagas;
  final List<String> beneficiosos;
  final List<String> perjudiciales;
  final Map<String, dynamic>? guiaRapida;

  const Cultivo({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.cientifico,
    required this.cosechaMeses,
    required this.tipo,
    required this.estacion,
    required this.identificacion,
    required this.siembra,
    required this.ficha,
    required this.plagas,
    this.beneficiosos = const [],
    this.perjudiciales = const [],
    this.guiaRapida,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        'cientifico': cientifico,
        'cosechaMeses': cosechaMeses,
        'tipo': tipo,
        'estacion': estacion,
        'identificacion': identificacion,
        'siembra': siembra,
        'ficha': ficha,
        'insectos': plagas,
        'beneficiosos': beneficiosos,
        'perjudiciales': perjudiciales,
        if (guiaRapida != null) 'guiaRapida': guiaRapida,
      };

  static Cultivo fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final plagas = (j['insectos'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final ben = (j['beneficiosos'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final per = (j['perjudiciales'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final guia = j['guiaRapida'] as Map<String, dynamic>?;

    return Cultivo(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      cientifico: (j['cientifico'] ?? '').toString(),
      cosechaMeses: (j['cosechaMeses'] ?? 0) is int
          ? (j['cosechaMeses'] as int)
          : int.tryParse('${j['cosechaMeses']}') ?? 0,
      tipo: (j['tipo'] ?? '').toString(),
      estacion: (j['estacion'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      siembra: (j['siembra'] ?? '').toString(),
      ficha: ficha,
      plagas: plagas,
      beneficiosos: ben,
      perjudiciales: per,
      guiaRapida: guia,
    );
  }
}

class _GuideDetail {
  final IconData icon;
  final String title;
  final String description;
  _GuideDetail(this.icon, this.title, this.description);
}

class CultivoDetallePage extends StatefulWidget {
  final Cultivo cultivo;
  const CultivoDetallePage({super.key, required this.cultivo});

  @override
  State<CultivoDetallePage> createState() => _CultivoDetallePageState();
}

class _CultivoDetallePageState extends State<CultivoDetallePage> {
  List<Observation> _observations = [];
  List<CropPlan> _plans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = await appDb.getActiveUserId();
    if (userId != null) {
      final obs = await appDb.getUserObservations(userId);
      final plans = await appDb.getAllPlansByCropName(userId, widget.cultivo.nombre);

      // Filter observations for this crop name
      final filteredObs = obs.where((o) => o.cropName == widget.cultivo.nombre).toList();
      filteredObs.sort((a, b) => a.date.compareTo(b.date));

      if (mounted) {
        setState(() {
          _observations = filteredObs;
          _plans = plans;
          _loading = false;
        });
      }
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _shareCrop(BuildContext context) async {
    await fileManagementService.shareModuleData(
      module: 'cultivo',
      name: widget.cultivo.nombre,
      data: widget.cultivo.toJson(),
      imagePath: widget.cultivo.imagePath,
      text: 'Mira mi cultivo: ${widget.cultivo.nombre}',
    );
  }


  Widget _buildImage() {
    if (widget.cultivo.imagePath != null &&
        widget.cultivo.imagePath!.isNotEmpty) {
      if (widget.cultivo.imagePath!.startsWith('data:image')) {
        return Image.memory(
          base64Decode(widget.cultivo.imagePath!.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.local_florist_rounded,
            color: AppColors.greenDarker,
          ),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            widget.cultivo.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.local_florist_rounded,
              color: AppColors.greenDarker,
            ),
          );
        } else {
          return Image.file(
            File(widget.cultivo.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.local_florist_rounded,
              color: AppColors.greenDarker,
            ),
          );
        }
      }
    }

    if (widget.cultivo.imagen.isNotEmpty) {
      return Image.asset(
        widget.cultivo.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.local_florist_rounded,
          color: AppColors.greenDarker,
        ),
      );
    }

    return const Icon(
      Icons.local_florist_rounded,
      color: AppColors.greenDarker,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return FutureBuilder<int?>(
      future: appDb.getActiveUserId(),
      builder: (context, snapshot) {
        final userId = snapshot.data;
        if (userId == null) return const SizedBox.shrink();

        return Column(
          children: [
            _buildStartPlanButton(context),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildStartPlanButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.greenDark.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showQuickGuide(context),
        icon: const Icon(Icons.calendar_today_rounded, color: Colors.white),
        label: const Text(
          'EMPEZAR PLAN DE CULTIVO',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _showQuickGuide(BuildContext context) async {
    final guia = widget.cultivo.guiaRapida ?? {};
    final userId = await appDb.getActiveUserId();
    SoilPreparation? activeSoil;
    if (userId != null) {
      activeSoil = await appDb.getActiveSoilPreparation(userId, widget.cultivo.nombre);
    }

    String soilStatus = 'No iniciado';
    Color soilColor = Colors.grey;
    String soilProgress = '';
    if (activeSoil != null) {
      final tasks = (jsonDecode(activeSoil.payloadJson) as List).map((e) => TareaPreparacion.fromJson(e)).toList();
      final progress = tasks.progress;
      soilProgress = '${(progress * 100).toInt()}%';

      if (activeSoil.completado || progress >= 1.0) {
        soilStatus = 'Listo';
        soilColor = Colors.green;
      } else {
        soilStatus = tasks.statusMessage;
        soilColor = Colors.orange;
      }
    }

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.greenDark.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_stories_rounded, color: AppColors.greenDark),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Guía Interactiva', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
                                  Text('Primeros pasos para tu cultivo', style: TextStyle(fontSize: 14, color: AppColors.greenSoft, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildInteractiveSection(
                          title: 'FASE 1: Preparación y Siembra',
                          subtitle: 'Base para un cultivo sano',
                          color: Colors.orange.shade800,
                          icon: Icons.looks_one_rounded,
                          items: [
                            _GuideDetail(Icons.layers, 'Preparación del suelo', 'Estado: $soilStatus ${soilProgress.isNotEmpty ? "($soilProgress)" : ""}'),
                            _GuideDetail(Icons.waves, 'Preparación de la tierra', guia['preparacionTierra'] ?? 'No especificado'),
                            _GuideDetail(Icons.grass, 'Siembra paso a paso', guia['comoSembrar'] ?? 'No especificado'),
                          ],
                          footer: Column(
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  if (activeSoil != null)
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: (jsonDecode(activeSoil.payloadJson) as List).map((e) => TareaPreparacion.fromJson(e)).toList().progress,
                                          backgroundColor: Colors.grey.shade200,
                                          color: soilColor,
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: soilColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    child: Text(soilStatus.toUpperCase(), style: TextStyle(color: soilColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      if (userId != null) {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => PreparacionSueloPage(userId: userId, initialCropName: widget.cultivo.nombre)));
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_forward, size: 16),
                                    label: const Text('Ver preparación del suelo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInteractiveSection(
                          title: 'FASE 2: GERMINACIÓN',
                          subtitle: 'Cuidados críticos',
                          color: Colors.blue.shade800,
                          icon: Icons.looks_two_rounded,
                          items: [
                            _GuideDetail(Icons.water_drop, 'Riego y humedad', guia['cuidadosGerminacion'] ?? 'No especificado'),
                            if (guia['usaAlmacigo'] == true) ...[
                              _GuideDetail(Icons.home_work_rounded, 'Tiempo en almácigo', '${guia['tiempoAlmacigo']} días'),
                              _GuideDetail(Icons.label_important_rounded, 'Cuándo trasplantar', guia['senalesTrasplante'] ?? 'No especificado'),
                            ],
                            _GuideDetail(Icons.straighten_rounded, 'Espaciado final', guia['distanciaTrasplante'] ?? 'No especificado'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            final userId = await appDb.getActiveUserId();
                            if (userId == null) return;
                            final activeSoil = await appDb.getActiveSoilPreparation(userId, widget.cultivo.nombre);

                            if (activeSoil == null) {
                              final res = await showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text('Suelo no preparado', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  content: const Text('No has realizado la preparación del suelo. Esto puede afectar tu cultivo.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'go'),
                                      child: const Text('IR A PREPARACIÓN'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, 'risk'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                      child: const Text('CONTINUAR BAJO RIESGO', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              if (res == 'go') {
                                if (context.mounted) {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => PreparacionSueloPage(userId: userId, initialCropName: widget.cultivo.nombre)));
                                }
                                return;
                              } else if (res == null) {
                                return;
                              }
                            } else if (!activeSoil.completado) {
                              final tasks = (jsonDecode(activeSoil.payloadJson) as List).map((e) => TareaPreparacion.fromJson(e)).toList();
                              final remainingDays = activeSoil.fechaListaSuelo != null
                                  ? activeSoil.fechaListaSuelo!.difference(DateTime.now()).inDays
                                  : 0;

                              final res = await showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text('Suelo en proceso', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  content: Text('Tu suelo aún no está listo (faltan ${remainingDays > 0 ? remainingDays : "X"} días)'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'wait'),
                                      child: const Text('ESPERAR'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, 'risk'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                      child: const Text('CONTINUAR BAJO RIESGO', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              if (res == 'wait') {
                                if (context.mounted) {
                                  _showStartPlanDialog(context, initialDate: activeSoil.fechaListaSuelo);
                                }
                                return;
                              } else if (res == 'risk') {
                                await appDb.updateSoilPreparation(SoilPreparationsCompanion(
                                  id: drift.Value(activeSoil.id),
                                  riesgo: const drift.Value(true),
                                ));
                              } else if (res == null) {
                                return;
                              }
                            }

                            if (context.mounted) _showStartPlanDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            shadowColor: AppColors.greenDark.withOpacity(0.4),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('LISTO, PROGRAMAR CULTIVO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInteractiveSection({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required List<_GuideDetail> items,
    Widget? footer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.1)),
                  Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                      child: Icon(item.icon, size: 18, color: AppColors.greenDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(item.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          if (footer != null) footer,
        ],
      ),
    );
  }


  Future<void> _showStartPlanDialog(BuildContext context, {DateTime? initialDate}) async {
    DateTime selectedDate = initialDate ?? DateTime.now();
    DateTime minDate = initialDate ?? DateTime.now().subtract(const Duration(days: 30));

    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
    final nicknameCtrl = TextEditingController();
    Color selectedColor = Colors.green;
    bool isAlmacigo = widget.cultivo.guiaRapida?['usaAlmacigo'] == true;

    final colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
    ];

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Programar Cultivo', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Dale un nombre y color a este cultivo para identificarlo en el calendario:'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nicknameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Apodo (ej: Lechuga de la abuela)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Color en el calendario:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: colors.map((c) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedColor = c),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == c ? Colors.black : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    ListTile(
                      title: const Text('Fecha de inicio'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: minDate,
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setState(() => selectedDate = picked);
                      },
                    ),
                    ListTile(
                      title: const Text('Hora de tareas'),
                      subtitle: Text(selectedTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) setState(() => selectedTime = picked);
                      },
                    ),
                    const Divider(),
                    CheckboxListTile(
                      title: const Text('¿Sembrar en almácigo?', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Si se selecciona, el plan incluirá una tarea de trasplante.'),
                      value: isAlmacigo,
                      activeColor: AppColors.greenDark,
                      onChanged: (v) => setState(() => isAlmacigo = v ?? false),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenDark, foregroundColor: Colors.white),
                  child: const Text('GENERAR PLAN'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final userId = await appDb.getActiveUserId();
      if (userId == null) return;

      try {
        await CropPlanGenerator.generate(
          userId: userId,
          cultivo: widget.cultivo,
          startDate: selectedDate,
          preferredTime: selectedTime,
          nickname: nicknameCtrl.text.trim().isEmpty ? null : nicknameCtrl.text.trim(),
          colorValue: selectedColor.value,
          isAlmacigoOverride: isAlmacigo,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Plan para ${widget.cultivo.nombre} generado con éxito.')),
          );

          // Using rootNavigator: true to ensure we jump out of any modal bottom sheets if they exist
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => CalendarioPage(userId: userId)),
            (route) => route.isFirst, // Goes back to Dashboard or whatever is the first route below this
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al generar el plan: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(widget.cultivo.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'Compartir',
              onPressed: () => _shareCrop(context),
              icon: const Icon(Icons.share_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            children: [
              _buildActionButtons(context),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildImage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_plans.isNotEmpty) ...[
                _buildPlansSection(),
                const SizedBox(height: 12),
              ],
              if (_observations.isNotEmpty) ...[
                _buildObservationsSection(),
                const SizedBox(height: 12),
              ],
              _DetailCard(
                icon: 'assets/iconos/id.png',
                title: 'Identificación',
                onHelp: () => HelpDialogs.show(context, title: 'Identificación', text: 'Descripción breve para reconocer el cultivo.'),
                child: Text(widget.cultivo.identificacion, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/siembra.png',
                title: 'Siembra',
                onHelp: () => HelpDialogs.show(context, title: 'Siembra', text: 'Consejos básicos para sembrar este cultivo.'),
                child: Text(widget.cultivo.siembra, style: TextStyle(color: AppColors.greenDarker.withOpacity(0.86), height: 1.35, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                icon: 'assets/iconos/indirecta.png',
                title: 'Ficha rápida',
                onHelp: () => HelpDialogs.show(context, title: 'Ficha rápida', text: 'Datos clave como distancia, profundidad, clima y riego.'),
                child: Column(
                  children: [
                    ...widget.cultivo.ficha.entries
                      .map((e) => _InfoRow(
                            label: e.key,
                            value: e.key == 'Temporada de siembra' || e.key == 'Temporada de cosecha'
                                ? AgriculturalLogic.mapSeasonToElSalvador(e.value)
                                : e.value,
                            onHelp: () => HelpDialogs.show(context, title: e.key, text: HelpDialogs.textForField(e.key)),
                          )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (widget.cultivo.plagas.isNotEmpty)
                _DetailCard(
                  icon: 'assets/iconos/id.png', // Reusing ID for now
                  title: 'Insectos',
                  onHelp: () => HelpDialogs.show(context, title: 'Insectos', text: 'Insectos comunes que pueden afectar este cultivo.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.cultivo.plagas.map((p) => _RelatedChip(name: p, type: 'plaga')).toList(),
                  ),
                ),
              if (widget.cultivo.beneficiosos.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailCard(
                  icon: 'assets/iconos/verano.png',
                  title: 'Cultivos Beneficiosos',
                  onHelp: () => HelpDialogs.show(context, title: 'Beneficiosos', text: 'Cultivos que crecen mejor junto a este.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.cultivo.beneficiosos.map((c) => _RelatedChip(name: c, type: 'cultivo')).toList(),
                  ),
                ),
              ],
              if (widget.cultivo.perjudiciales.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailCard(
                  icon: 'assets/iconos/invierno.png',
                  title: 'Cultivos Perjudiciales',
                  onHelp: () => HelpDialogs.show(context, title: 'Perjudiciales', text: 'Cultivos que deben evitarse cerca de este.'),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.cultivo.perjudiciales.map((c) => _RelatedChip(name: c, type: 'cultivo')).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansSection() {
    return _DetailCard(
      icon: 'assets/iconos/calendario.png',
      title: 'Planes en curso / Finalizados',
      onHelp: () => HelpDialogs.show(context, title: 'Planes', text: 'Planes de cultivo asociados a esta planta.'),
      child: Column(
        children: _plans.map((p) {
          final color = p.colorValue != null ? Color(p.colorValue!) : AppColors.greenDark;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.nickname ?? p.cropName, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                      Text(
                        'Estado: ${p.status == 'active' ? 'Activo' : 'Finalizado'}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(p.startDate),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildObservationsSection() {
    final plansMap = {for (var p in _plans) p.id: p};
    return _DetailCard(
      icon: 'assets/iconos/id.png',
      title: 'Historial de Observaciones',
      onHelp: () => HelpDialogs.show(context, title: 'Historial', text: 'Registro cronológico de lo que has observado en este cultivo.'),
      child: Column(
        children: _observations.map((obs) {
          final plan = obs.planId != null ? plansMap[obs.planId] : null;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greenDark.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(obs.date),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.greenDark),
                    ),
                    if (plan != null)
                      Text(
                        'Semana ${obs.date.difference(plan.startDate).inDays ~/ 7 + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(obs.content, style: const TextStyle(fontSize: 13, height: 1.3)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    if (obs.plantStatus != null) _miniTag(obs.plantStatus!, Colors.blueGrey),
                    if (obs.hasIrrigation) const Icon(Icons.water_drop, size: 14, color: Colors.blue),
                    if (obs.hasPest) const Icon(Icons.bug_report, size: 14, color: Colors.red),
                    if (obs.hasFertilization) const Icon(Icons.science_rounded, size: 14, color: Colors.orange),
                    if (obs.hasTransplant) const Icon(Icons.import_export_rounded, size: 14, color: Colors.teal),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _miniTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onHelp;
  final Widget child;

  const _DetailCard({required this.icon, required this.title, required this.onHelp, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.info_outline)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 16)),
              const Spacer(),
              IconButton(onPressed: onHelp, icon: const Icon(Icons.help_outline_rounded), color: AppColors.greenDarker),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onHelp;
  const _InfoRow({required this.label, required this.value, required this.onHelp});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Expanded(child: Text('$label\n$value', style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w700, height: 1.25))),
          IconButton(onPressed: onHelp, icon: const Icon(Icons.help_outline_rounded), color: AppColors.greenDarker),
        ],
      ),
    );
  }
}

class _RelatedChip extends StatefulWidget {
  final String name;
  final String type; // 'cultivo' or 'plaga'

  const _RelatedChip({required this.name, required this.type});

  @override
  State<_RelatedChip> createState() => _RelatedChipState();
}

class _RelatedChipState extends State<_RelatedChip> {
  String? _assetPath;
  bool _loaded = false;
  dynamic _targetItem;

  @override
  void initState() {
    super.initState();
    _loadItemInfo();
  }

  Future<void> _loadItemInfo() async {
    try {
      final String jsonAssetPath = widget.type == 'cultivo' ? 'assets/data/cultivos.json' : 'assets/data/plagas.json';
      final raw = await rootBundle.loadString(jsonAssetPath);
      final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
      final decoded = jsonDecode(cleanJson) as List;

      if (widget.type == 'cultivo') {
        final catalog = decoded.map((e) => Cultivo.fromJson(Map<String, dynamic>.from(e))).toList();
        _targetItem = catalog.firstWhere((i) => i.nombre.toLowerCase() == widget.name.toLowerCase());
        _assetPath = (_targetItem as Cultivo).imagen;
      } else {
        final catalog = decoded.map((e) => Plaga.fromJson(Map<String, dynamic>.from(e))).toList();
        _targetItem = catalog.firstWhere((i) => i.nombre.toLowerCase() == widget.name.toLowerCase());
        _assetPath = (_targetItem as Plaga).imagen;
      }
      if (mounted) setState(() => _loaded = true);
    } catch (e) {
      // Silently fail if not found
    }
  }

  Widget _buildThumb() {
    final IconData fallbackIcon = widget.type == 'cultivo'
        ? Icons.local_florist_rounded
        : Icons.bug_report_rounded;

    if (!_loaded || _assetPath == null || _assetPath!.isEmpty) {
      return Icon(fallbackIcon, size: 16, color: AppColors.greenDarker);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        _assetPath!,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(fallbackIcon, size: 16, color: AppColors.greenDarker),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_targetItem == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sin detalle para: ${widget.name}')));
          return;
        }
        if (widget.type == 'cultivo') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CultivoDetallePage(cultivo: _targetItem as Cultivo)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => PlagaDetallePage(plaga: _targetItem as Plaga)));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greenDark.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThumb(),
            const SizedBox(width: 6),
            Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.greenDarker)),
          ],
        ),
      ),
    );
  }
}
