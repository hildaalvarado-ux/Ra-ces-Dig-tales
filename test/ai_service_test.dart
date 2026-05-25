import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:raices_digitalesv1/data/app_database.dart';
import 'package:raices_digitalesv1/data/db_instance.dart';
import 'package:raices_digitalesv1/data/ai_service.dart';
import 'package:raices_digitalesv1/datos/plaga_detalle.dart';
import 'package:raices_digitalesv1/datos/pesticida_detalle.dart';
import 'package:drift/drift.dart' hide Column;

class TestDatabase extends AppDatabase {
  TestDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = TestDatabase();
    appDb = db;

    // Insertar datos de prueba en las tablas de Drift
    const plaga = Plaga(
      nombre: 'Pulgón',
      cientifico: 'Aphididae',
      descripcion: 'Pequeños insectos que succionan la savia. Dejan hojas pegajosas.',
      sintomas: '',
      danos: '',
      causas: '',
      control: '',
      identificacion: '',
      imagen: '',
      ficha: {},
    );

    await db.into(db.userPlagas).insert(UserPlagasCompanion.insert(
      userId: 1,
      nombre: Value('Pulgón'),
      cientifico: Value('Aphididae'),
      payloadJson: jsonEncode(plaga.toJson()),
    ));

    const pest = Pesticida(
      nombre: 'Jabón Potásico',
      tipo: 'Insecticida',
      identificacion: '',
      uso: 'Pulgón, Mosca Blanca',
      imagen: '',
      ficha: {},
      plagas: ['Pulgón', 'Mosca Blanca'],
    );

    await db.into(db.userPesticidas).insert(UserPesticidasCompanion.insert(
      userId: 1,
      nombre: Value('Jabón Potásico'),
      tipo: Value('Insecticida'),
      payloadJson: jsonEncode(pest.toJson()),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  test('AgriculturalAIService detecta gravedad alta por palabras clave', () async {
    final result = await aiService.analyzeIncident('Es urgente, mis plantas se están muriendo rápido.');
    expect(result.severity, equals('Crítica'));
  });

  test('AgriculturalAIService detecta pulgones por descripción', () async {
    final result = await aiService.analyzeIncident('Veo insectos pequeños y las hojas están muy pegajosas.');
    expect(result.detectedPests.any((p) => p.nombre == 'Pulgón'), isTrue);
    expect(result.suggestedPesticides.any((p) => p.nombre == 'Jabón Potásico'), isTrue);
  });
}
