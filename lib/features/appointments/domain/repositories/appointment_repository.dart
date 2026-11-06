import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAll();
  Future<void> add(Appointment appointment);
}
