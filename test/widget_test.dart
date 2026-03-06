import 'package:flutter_test/flutter_test.dart';
import 'package:raices_digitalesv1/main.dart';

void main() {
  testWidgets('App starts and shows welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Splash screen is shown first.
    expect(find.text('Raíces Digitales'), findsOneWidget);

    // Wait for the splash screen to transition (3 seconds + buffer).
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that we are on the welcome page.
    expect(find.text('BIENVENIDO'), findsOneWidget);
    expect(find.text('CREAR CUENTA'), findsOneWidget);
  });
}
