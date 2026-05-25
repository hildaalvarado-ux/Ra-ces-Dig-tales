import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'app_database.dart';
import 'db_instance.dart';
import 'crop_models.dart';
import '../datos/plaga_detalle.dart';
import '../datos/enfermedad_detalle.dart';
import '../datos/pesticida_detalle.dart';
import '../datos/fertilizante_detalle.dart';

class AIAnalysisResult {
  final String summary;
  final String severity;
  final List<String> recommendations;
  final List<Plaga> detectedPests;
  final List<Enfermedad> detectedDiseases;
  final List<Pesticida> suggestedPesticides;
  final List<Fertilizante> suggestedFertilizers;

  AIAnalysisResult({
    required this.summary,
    required this.severity,
    required this.recommendations,
    required this.detectedPests,
    required this.detectedDiseases,
    required this.suggestedPesticides,
    required this.suggestedFertilizers,
  });
}

class AgriculturalAIService {
  static final AgriculturalAIService _instance = AgriculturalAIService._internal();
  factory AgriculturalAIService() => _instance;
  AgriculturalAIService._internal();

  Future<AIAnalysisResult> analyzeIncident(String description) async {
    // Simulamos un retraso de red para la IA
    await Future.delayed(const Duration(seconds: 2));

    final text = description.toLowerCase();

    // Lógica de detección por palabras clave (simulando IA contextual)
    String severity = 'Baja';
    if (text.contains('muere') || text.contains('muriendo') || text.contains('toda la planta') || text.contains('urgente')) {
      severity = 'Crítica';
    } else if (text.contains('muchos') || text.contains('extendiendo') || text.contains('grave')) {
      severity = 'Alta';
    } else if (text.contains('algunos') || text.contains('manchas') || text.contains('amarillo')) {
      severity = 'Media';
    }

    // Buscar en el catálogo local coincidencias
    final allPests = await _getAllPests();
    final allDiseases = await _getAllDiseases();
    final allPesticides = await _getAllPesticides();
    final allFertilizers = await _getAllFertilizers();

    List<Plaga> detectedPests = [];
    List<Enfermedad> detectedDiseases = [];
    List<Pesticida> suggestedPesticides = [];
    List<Fertilizante> suggestedFertilizers = [];

    // Emparejamiento simple por nombre/palabras clave en descripción
    for (var p in allPests) {
      if (text.contains(p.nombre.toLowerCase()) || _containsKeywords(text, p.descripcion)) {
        detectedPests.add(p);
      }
    }

    for (var d in allDiseases) {
      if (text.contains(d.nombre.toLowerCase()) || _containsKeywords(text, d.descripcion)) {
        detectedDiseases.add(d);
      }
    }

    // Sugerir tratamientos basados en las plagas/enfermedades detectadas
    for (var p in detectedPests) {
      for (var pest in allPesticides) {
        if (pest.plagas.any((pestName) => pestName.toLowerCase().contains(p.nombre.toLowerCase()))) {
          if (!suggestedPesticides.any((item) => item.nombre == pest.nombre)) suggestedPesticides.add(pest);
        }
      }
    }

    for (var d in detectedDiseases) {
      for (var pest in allPesticides) {
        // En Pesticida modelo, no hay campo explícito para enfermedades, pero solemos buscarlos en 'identificacion' o 'uso'
        if (pest.uso.toLowerCase().contains(d.nombre.toLowerCase()) || pest.identificacion.toLowerCase().contains(d.nombre.toLowerCase())) {
          if (!suggestedPesticides.any((item) => item.nombre == pest.nombre)) suggestedPesticides.add(pest);
        }
      }
    }

    // Recomendaciones generales si no hay nada específico
    List<String> recommendations = [
      'Aísla las plantas afectadas si es posible para evitar la propagación.',
      'Revisa el riego: el exceso de humedad suele atraer hongos y plagas.',
      'Aplica una solución preventiva de jabón potásico o aceite de neem si ves insectos.',
    ];

    if (severity == 'Crítica' || severity == 'Alta') {
      recommendations.insert(0, 'Considera eliminar las partes más afectadas de inmediato.');
    }

    String summary = 'Según tu descripción, parece ser un problema de nivel $severity. ';
    List<String> detections = [];
    if (detectedPests.isNotEmpty) {
      detections.add('indicios de ${detectedPests.map((e) => e.nombre).join(", ")}');
    }
    if (detectedDiseases.isNotEmpty) {
      detections.add('posible relación con ${detectedDiseases.map((e) => e.nombre).join(", ")}');
    }

    if (detections.isNotEmpty) {
      summary += 'He detectado ${detections.join(" y ")}. ';
    } else {
      summary += 'No he encontrado una plaga o enfermedad específica en el catálogo, pero los síntomas sugieren estrés ambiental o deficiencia de nutrientes.';
      // Sugerir fertilizante general si no hay plaga/enfermedad
      if (allFertilizers.isNotEmpty) suggestedFertilizers.add(allFertilizers.first);
    }

    return AIAnalysisResult(
      summary: summary,
      severity: severity,
      recommendations: recommendations,
      detectedPests: detectedPests,
      detectedDiseases: detectedDiseases,
      suggestedPesticides: suggestedPesticides,
      suggestedFertilizers: suggestedFertilizers,
    );
  }

  bool _containsKeywords(String text, String source) {
    final keywords = ['hoja', 'tallo', 'puntos', 'blanco', 'negro', 'amarillo', 'seco', 'insecto', 'mancha'];
    int matches = 0;
    for (var kw in keywords) {
      if (text.contains(kw) && source.toLowerCase().contains(kw)) {
        matches++;
      }
    }
    return matches >= 2;
  }

  // Helpers to get data from multiple sources (User + Shared)
  Future<List<Plaga>> _getAllPests() async {
    final user = await appDb.select(appDb.userPlagas).get();
    final shared = await appDb.select(appDb.sharedPlagas).get();

    List<Plaga> list = [];
    for (var row in user) {
      final data = jsonDecode(row.payloadJson);
      list.add(Plaga.fromJson(data));
    }
    for (var row in shared) {
      final data = jsonDecode(row.payloadJson);
      list.add(Plaga.fromJson(data));
    }
    return list;
  }

  Future<List<Enfermedad>> _getAllDiseases() async {
    final user = await appDb.select(appDb.userEnfermedades).get();
    final shared = await appDb.select(appDb.sharedEnfermedades).get();

    List<Enfermedad> list = [];
    for (var row in user) {
      final data = jsonDecode(row.payloadJson);
      list.add(Enfermedad.fromJson(data));
    }
    for (var row in shared) {
      final data = jsonDecode(row.payloadJson);
      list.add(Enfermedad.fromJson(data));
    }
    return list;
  }

  Future<List<Pesticida>> _getAllPesticides() async {
    final user = await appDb.select(appDb.userPesticidas).get();
    final shared = await appDb.select(appDb.sharedPesticidas).get();

    List<Pesticida> list = [];
    for (var row in user) {
      final data = jsonDecode(row.payloadJson);
      list.add(Pesticida.fromJson(data));
    }
    for (var row in shared) {
      final data = jsonDecode(row.payloadJson);
      list.add(Pesticida.fromJson(data));
    }
    return list;
  }

  Future<List<Fertilizante>> _getAllFertilizers() async {
    final user = await appDb.select(appDb.userFertilizantes).get();
    final shared = await appDb.select(appDb.sharedFertilizantes).get();

    List<Fertilizante> list = [];
    for (var row in user) {
      final data = jsonDecode(row.payloadJson);
      list.add(Fertilizante.fromJson(data));
    }
    for (var row in shared) {
      final data = jsonDecode(row.payloadJson);
      list.add(Fertilizante.fromJson(data));
    }
    return list;
  }
}

final aiService = AgriculturalAIService();
