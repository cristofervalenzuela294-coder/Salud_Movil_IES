import '../entities/patient.dart';

/// Contrato de acceso a fichas. En el Hito 6 se implementa con SQLite (DAO).
abstract class PatientRepository {
  Future<List<Patient>> getAll();
  Future<void> add(Patient patient);
  Future<void> markAllSynced();
}
