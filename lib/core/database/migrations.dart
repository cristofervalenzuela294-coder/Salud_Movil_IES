import 'package:sqflite/sqflite.dart';

/// Migraciones del esquema SQLite, una lista de sentencias por versión.
///
/// Para cambiar el esquema: agregar una nueva versión aquí y subir [latest].
/// Nunca se edita una migración que ya se publicó.
class Migrations {
  static const latest = 2;

  static const Map<int, List<String>> _scripts = {
    // v1: tablas base
    1: [
      '''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dni TEXT NOT NULL,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        reason TEXT NOT NULL,
        level INTEGER NOT NULL,
        systolic INTEGER,
        diastolic INTEGER,
        spo2 INTEGER,
        heart_rate INTEGER,
        pain INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        specialty TEXT NOT NULL,
        sede TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        confirmed INTEGER NOT NULL DEFAULT 0
      )
      ''',
    ],
    // v2: fecha de registro e índice por prioridad
    2: [
      'ALTER TABLE patients ADD COLUMN created_at TEXT',
      'CREATE INDEX idx_patients_level ON patients(level)',
    ],
  };

  /// Aplica las migraciones de la versión [from]+1 hasta [to].
  static Future<void> apply(Database db, int from, int to) async {
    for (var v = from + 1; v <= to; v++) {
      for (final sql in _scripts[v]!) {
        await db.execute(sql);
      }
    }
  }
}
