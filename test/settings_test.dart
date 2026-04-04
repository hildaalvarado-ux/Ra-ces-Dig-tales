import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:raices_digitalesv1/data/settings_provider.dart';

void main() {
  testWidgets('SettingsProvider updates text scale factor', (WidgetTester tester) async {
    final settingsProvider = SettingsProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>.value(
        value: settingsProvider,
        child: MaterialApp(
          builder: (context, child) {
            final settings = Provider.of<SettingsProvider>(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(settings.textScaleFactor),
              ),
              child: child!,
            );
          },
          home: const Scaffold(
            body: Text('Test Text'),
          ),
        ),
      ),
    );

    // Default scale should be 1.0
    expect(tester.widget<RichText>(find.byType(RichText).first).textScaler, TextScaler.linear(1.0));

    // Change to small
    settingsProvider.setTextSize(AppTextSize.pequeno);
    await tester.pumpAndSettle();
    expect(tester.widget<RichText>(find.byType(RichText).first).textScaler, TextScaler.linear(0.85));

    // Change to large
    settingsProvider.setTextSize(AppTextSize.grande);
    await tester.pumpAndSettle();
    expect(tester.widget<RichText>(find.byType(RichText).first).textScaler, TextScaler.linear(1.25));
  });
}
