import 'package:sqflite/sqflite.dart';

import '../../domain/entities/appointment.dart';
import '../models/appointment_model.dart';

class AppointmentDao {
  AppointmentDao(this._db);
  final Database _db;
  static const table = 'appointments';

  Future<int> insert(Appointment a) => _db.insert(table, AppointmentModel.toMap(a));

  Future<List<Appointment>> getAll() async {
    final rows = await _db.query(table, orderBy: 'id ASC');
    return rows.map(AppointmentModel.fromMap).toList();
  }

  Future<int> update(Appointment a) => _db.update(
      table, AppointmentModel.toMap(a), where: 'id = ?', whereArgs: [a.id]);

  Future<int> delete(int id) => _db.delete(table, where: 'id = ?', whereArgs: [id]);

  Future<int> count() async =>
      Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
}
