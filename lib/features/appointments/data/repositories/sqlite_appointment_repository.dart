import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_dao.dart';
import '../seed/demo_appointments.dart';

class SqliteAppointmentRepository implements AppointmentRepository {
  SqliteAppointmentRepository(this._dao);
  final AppointmentDao _dao;

  Future<void> seedIfEmpty() async {
    if (await _dao.count() == 0) {
      for (final a in demoAppointments) {
        await _dao.insert(a);
      }
    }
  }

  @override
  Future<List<Appointment>> getAll() => _dao.getAll();

  @override
  Future<void> add(Appointment appointment) async {
    await _dao.insert(appointment);
  }
}
