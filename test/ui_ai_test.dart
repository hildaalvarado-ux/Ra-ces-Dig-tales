import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:raices_digitalesv1/data/app_database.dart';
import 'package:raices_digitalesv1/data/db_instance.dart';
import 'package:raices_digitalesv1/datos/calendario.dart';
import 'package:raices_digitalesv1/main.dart';

void main() {
  setUp(() {
    appDb = AppDatabase.forTesting(NativeDatabase.memory());
  });

  testWidgets('El diálogo de reporte de incidente contiene el botón ANALIZAR CON IA', (WidgetTester tester) async {
    // Setup a dummy task
    final task = CalendarTask(
      id: 1,
      userId: 1,
      title: 'Tarea Test',
      date: DateTime.now(),
      completed: false,
      type: 'riego',
      planId: null,
    );

    // Build the dialog
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarioPage.getIncidentReportDialog(
          task: task,
          onReport: () {},
        ),
      ),
    ));

    // Verify button exists
    expect(find.text('ANALIZAR CON IA'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome), findsAtLeast(1));

    // Enter some text
    await tester.enterText(find.byType(TextField), 'Tengo pulgones');
    await tester.pump();

    // Tap the button
    await tester.tap(find.text('ANALIZAR CON IA'));
    await tester.pump(); // Start analysis

    expect(find.text('ANALIZANDO...'), findsOneWidget);

    // Wait for the timer to finish
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify results appeared (Summary text from AI service)
    expect(find.textContaining('Análisis Inteligente'), findsOneWidget);
  });
}
