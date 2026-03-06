import 'package:drift/drift.dart';
import 'package:drift/web.dart';

DatabaseConnection createConnection() {
  // ✅ Guardado persistente en IndexedDB en el navegador
  return DatabaseConnection(WebDatabase('raices'));
}