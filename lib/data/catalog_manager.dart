import 'dart:convert';
import 'package:flutter/services.dart';
import '../datos/cultivo_detalle.dart';
import '../datos/fertilizante_detalle.dart';
import '../datos/plaga_detalle.dart';
import '../datos/pesticida_detalle.dart';

class CatalogManager {
  static final CatalogManager _instance = CatalogManager._internal();
  factory CatalogManager() => _instance;
  CatalogManager._internal();

  List<Cultivo>? _crops;
  List<Fertilizante>? _fertilizers;
  List<Plaga>? _pests;
  List<Pesticida>? _pesticides;

  Future<List<Cultivo>> getCrops() async {
    if (_crops != null) return _crops!;
    final raw = await rootBundle.loadString('assets/data/cultivos.json');
    final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
    final decoded = jsonDecode(cleanJson) as List;
    _crops = decoded.map((e) => Cultivo.fromJson(Map<String, dynamic>.from(e))).toList();
    return _crops!;
  }

  Future<List<Fertilizante>> getFertilizers() async {
    if (_fertilizers != null) return _fertilizers!;
    final raw = await rootBundle.loadString('assets/data/fertilizantes.json');
    final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
    final decoded = jsonDecode(cleanJson) as List;
    _fertilizers = decoded.map((e) => Fertilizante.fromJson(Map<String, dynamic>.from(e))).toList();
    return _fertilizers!;
  }

  Future<List<Plaga>> getPests() async {
    if (_pests != null) return _pests!;
    final raw = await rootBundle.loadString('assets/data/plagas.json');
    final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
    final decoded = jsonDecode(cleanJson) as List;
    _pests = decoded.map((e) => Plaga.fromJson(Map<String, dynamic>.from(e))).toList();
    return _pests!;
  }

  Future<List<Pesticida>> getPesticides() async {
    if (_pesticides != null) return _pesticides!;
    final raw = await rootBundle.loadString('assets/data/pesticidas.json');
    final cleanJson = raw.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
    final decoded = jsonDecode(cleanJson) as List;
    _pesticides = decoded.map((e) => Pesticida.fromJson(Map<String, dynamic>.from(e))).toList();
    return _pesticides!;
  }

  Future<void> loadAll() async {
    await Future.wait([
      getCrops(),
      getFertilizers(),
      getPests(),
      getPesticides(),
    ]);
  }
}

final catalogManager = CatalogManager();
