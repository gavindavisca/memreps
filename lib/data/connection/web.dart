import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor connect() {
  // This uses the sql-asm.js library from the CDN (added to index.html).
  // It provides a pure JavaScript SQLite engine that works in any browser 
  // without the 'application/wasm' MIME type issues.
  return WebDatabase.withStorage(DriftWebStorage.indexedDb('db'));
}
