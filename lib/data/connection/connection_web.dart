import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

DatabaseConnection createConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'raices',
      sqlite3Uri: Uri.parse('sql-wasm.wasm'),
      driftWorkerUri: Uri.parse('sql-wasm.js'), // Usamos el JS de sql-wasm como worker si es necesario, o drift_dev debería proveer uno
    );

    if (result.missingFeatures.isNotEmpty) {
      // ignore: avoid_print
      print('Advertencia: Faltan características en el navegador: \${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));
}
