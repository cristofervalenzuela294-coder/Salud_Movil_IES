import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../seed/demo_appointments.dart';

class InMemoryAppointmentRepository implements AppointmentRepository {
  final List<Appointment> _items = [...demoAppointments];

  @override
  Future<List<Appointment>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> add(Appointment appointment) async => _items.add(appointment);
}
