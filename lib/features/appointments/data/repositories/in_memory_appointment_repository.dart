import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../seed/demo_appointments.dart';

class InMemoryAppointmentRepository implements AppointmentRepository {
  InMemoryAppointmentRepository() {
    for (final a in demoAppointments) {
      _items.add(a.copyWith(id: _nextId++));
    }
  }

  final List<Appointment> _items = [];
  int _nextId = 1;

  @override
  Future<List<Appointment>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> add(Appointment a) async => _items.add(a.copyWith(id: _nextId++));

  @override
  Future<void> update(Appointment a) async {
    final i = _items.indexWhere((x) => x.id == a.id);
    if (i >= 0) _items[i] = a;
  }

  @override
  Future<void> delete(int id) async => _items.removeWhere((a) => a.id == id);
}
