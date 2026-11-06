import 'package:sqflite/sqflite.dart';

import '../../domain/entities/patient.dart';
import '../models/patient_model.dart';

/// Acceso a la tabla `patients` (patrón DAO).
class PatientDao {
  PatientDao(this._db);
  final Database _db;
  static const table = 'patients';

  Future<int> insert(Patient p) => _db.insert(table, {
        ...PatientModel.toMap(p),
        'created_at': DateTime.now().toIso8601String(),
      });

  Future<List<Patient>> getAll() async {
    final rows = await _db.query(table, orderBy: 'level ASC, name ASC');
    return rows.map(PatientModel.fromMap).toList();
  }

  Future<Patient?> getById(int id) async {
    final rows = await _db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : PatientModel.fromMap(rows.first);
  }

  Future<int> update(Patient p) =>
      _db.update(table, PatientModel.toMap(p), where: 'id = ?', whereArgs: [p.id]);

  Future<int> delete(int id) => _db.delete(table, where: 'id = ?', whereArgs: [id]);

  Future<int> markAllSynced() =>
      _db.update(table, {'synced': 1}, where: 'synced = 0');

  Future<int> count() async =>
      Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
}
