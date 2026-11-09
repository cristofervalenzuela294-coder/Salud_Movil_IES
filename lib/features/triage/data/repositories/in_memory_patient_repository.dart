import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../seed/demo_patients.dart';

/// Implementación en memoria, útil para pruebas.
class InMemoryPatientRepository implements PatientRepository {
  InMemoryPatientRepository() {
    for (final p in demoPatients()) {
      _items.add(p.copyWith(id: _nextId++));
    }
  }

  final List<Patient> _items = [];
  int _nextId = 1;

  @override
  Future<List<Patient>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> add(Patient patient) async =>
      _items.add(patient.copyWith(id: _nextId++));

  @override
  Future<void> update(Patient patient) async {
    final i = _items.indexWhere((p) => p.id == patient.id);
    if (i >= 0) _items[i] = patient;
  }

  @override
  Future<void> delete(int id) async => _items.removeWhere((p) => p.id == id);

  @override
  Future<void> markAllSynced() async {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(synced: true);
    }
  }
}
