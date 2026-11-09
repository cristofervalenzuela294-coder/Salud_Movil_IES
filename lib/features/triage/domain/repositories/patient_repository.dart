import '../entities/patient.dart';

/// Contrato de acceso a fichas (CRUD completo).
abstract class PatientRepository {
  Future<List<Patient>> getAll();
  Future<void> add(Patient patient);
  Future<void> update(Patient patient);
  Future<void> delete(int id);
  Future<void> markAllSynced();
}
