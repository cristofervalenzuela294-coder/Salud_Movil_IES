import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'migrations.dart';

class AppDatabase {
  static const fileName = 'saludmovil.db';

  /// Abre (y crea o migra) la base de datos local.
  /// Pase [path] para usar otra ruta, por ejemplo `inMemoryDatabasePath` en pruebas.
  static Future<Database> open({String? path}) async {
    final dbPath = path ?? p.join(await getDatabasesPath(), fileName);
    debugPrint('SQLite: $dbPath');
    return openDatabase(
      dbPath,
      version: Migrations.latest,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) => Migrations.apply(db, 0, version),
      onUpgrade: (db, oldVersion, newVersion) =>
          Migrations.apply(db, oldVersion, newVersion),
    );
  }
}
