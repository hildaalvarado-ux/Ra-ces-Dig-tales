import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:raices_digitalesv1/datos/diario.dart';
import 'package:provider/provider.dart';
import 'package:raices_digitalesv1/data/settings_provider.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_ES', null);
  });

  testWidgets('DiarioPage shows title', (WidgetTester tester) async {
    // We wrap in a Scaffold and MaterialApp to provide context
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
        child: const MaterialApp(
          home: DiarioPage(userId: 1),
        ),
      ),
    );

    expect(find.text('Diario de Observaciones'), findsOneWidget);
  });
}
