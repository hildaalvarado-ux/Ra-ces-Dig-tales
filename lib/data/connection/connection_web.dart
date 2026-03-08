import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

DatabaseConnection createConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'raices',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    // opcional: avisos del navegador
    if (result.missingFeatures.isNotEmpty) {
      // ignore: avoid_print
      print('Advertencia: faltan features: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));
}