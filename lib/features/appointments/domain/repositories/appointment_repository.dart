import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAll();
  Future<void> add(Appointment appointment);
  Future<void> update(Appointment appointment);
  Future<void> delete(int id);
}
