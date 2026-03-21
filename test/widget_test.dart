import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raices_digitalesv1/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Splash screen is shown first.
    expect(find.text('Raíces Digitales'), findsOneWidget);

    // Check for some text in splash
    expect(find.text('“Crece con cada idea, construye con cada paso.”'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    // Additional pump to clear any other microtasks or zero-duration timers
    await tester.pump(const Duration(milliseconds: 100));
  });
}
