import '../entities/patient.dart';

/// Contrato del servicio web de fichas. Lanza `Failure` ante errores de red o del servidor.
abstract class PatientRemote {
  /// Crea la ficha en el servidor y devuelve su identificador remoto.
  Future<int> create(Patient patient);
  Future<void> update(int remoteId, Patient patient);
  Future<List<Patient>> fetchAll();
}
