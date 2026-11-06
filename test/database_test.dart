import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:saludmovil_ies/core/database/app_database.dart';
import 'package:saludmovil_ies/core/database/migrations.dart';
import 'package:saludmovil_ies/features/triage/data/datasources/patient_dao.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/patient.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/triage_level.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/vital_signs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('crea las tablas en la versión más reciente', () async {
    final db = await AppDatabase.open(path: inMemoryDatabasePath);
    final tables = (await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type = 'table'"))
        .map((r) => r['name'])
        .toList();
    expect(tables, containsAll(['patients', 'appointments']));
    expect(await db.getVersion(), Migrations.latest);
    await db.close();
  });

  test('PatientDao: insertar, leer, actualizar y eliminar', () async {
    final db = await AppDatabase.open(path: inMemoryDatabasePath);
    final dao = PatientDao(db);
    final id = await dao.insert(const Patient(
      name: 'Test',
      age: 30,
      reason: 'Control',
      level: TriageLevel.v,
      dni: '12345678',
      vitals: VitalSigns(
          systolic: 120, diastolic: 80, spo2: 98, heartRate: 75, pain: 0),
    ));

    var all = await dao.getAll();
    expect(all.single.id, id);
    expect(all.single.name, 'Test');
    expect(all.single.vitals?.spo2, 98);
    expect(all.single.synced, isFalse);

    await dao.update(all.single.copyWith(synced: true));
    all = await dao.getAll();
    expect(all.single.synced, isTrue);

    await dao.delete(id);
    expect(await dao.count(), 0);
    await db.close();
  });

  test('migración de v1 a v2 conserva los datos y agrega created_at', () async {
    final dir = await Directory.systemTemp.createTemp('saludmovil_test');
    final path = p.join(dir.path, 'test.db');

    final v1 = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, v) => Migrations.apply(db, 0, 1),
      ),
    );
    await v1.insert('patients', {
      'dni': '12345678',
      'name': 'Antiguo',
      'age': 40,
      'reason': 'Control',
      'level': 4,
      'synced': 0,
    });
    await v1.close();

    final db = await AppDatabase.open(path: path);
    final cols = (await db.rawQuery('PRAGMA table_info(patients)'))
        .map((r) => r['name'])
        .toList();
    expect(cols, contains('created_at'));
    expect((await db.query('patients')).length, 1);
    await db.close();
    await dir.delete(recursive: true);
  });
}
