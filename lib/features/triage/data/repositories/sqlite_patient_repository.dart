import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_dao.dart';
import '../seed/demo_patients.dart';

/// Repositorio de fichas respaldado por SQLite (funciona sin conexión).
class SqlitePatientRepository implements PatientRepository {
  SqlitePatientRepository(this._dao);
  final PatientDao _dao;

  /// Carga los pacientes de ejemplo solo si la tabla está vacía.
  Future<void> seedIfEmpty() async {
    if (await _dao.count() == 0) {
      for (final p in demoPatients()) {
        await _dao.insert(p);
      }
    }
  }

  @override
  Future<List<Patient>> getAll() => _dao.getAll();

  @override
  Future<void> add(Patient patient) async {
    await _dao.insert(patient);
  }

  @override
  Future<void> markAllSynced() async {
    await _dao.markAllSynced();
  }
}
