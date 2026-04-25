import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:raices_digitalesv1/main.dart';
import 'package:raices_digitalesv1/data/settings_provider.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
       await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
          child: const MyApp(),
        ),
      );

      // Splash screen is shown first.
      expect(find.text('Raíces Digitales'), findsOneWidget);

      // Check for some text in splash
      expect(find.text('“Crece con cada idea, construye con cada paso.”'), findsOneWidget);
    });
  });
}
