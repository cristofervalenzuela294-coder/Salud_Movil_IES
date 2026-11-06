import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../seed/demo_patients.dart';

/// Implementación en memoria, útil para pruebas.
class InMemoryPatientRepository implements PatientRepository {
  InMemoryPatientRepository() {
    _items.addAll(demoPatients());
  }

  final List<Patient> _items = [];

  @override
  Future<List<Patient>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> add(Patient patient) async => _items.add(patient);

  @override
  Future<void> markAllSynced() async {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(synced: true);
    }
  }
}
