import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/error/failures.dart';
import 'package:saludmovil_ies/features/triage/data/repositories/in_memory_patient_repository.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/patient.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/triage_level.dart';
import 'package:saludmovil_ies/features/triage/domain/repositories/patient_remote.dart';
import 'package:saludmovil_ies/features/triage/domain/usecases/sync_patients.dart';

class _FakeRemote implements PatientRemote {
  final List<Patient> stored = [
    const Patient(
        remoteId: 999,
        name: 'Remoto R.',
        age: 33,
        reason: 'Control',
        level: TriageLevel.v,
        synced: true),
  ];
  int _next = 100;

  @override
  Future<int> create(Patient p) async {
    final id = _next++;
    stored.add(p.copyWith(remoteId: id));
    return id;
  }

  @override
  Future<void> update(int remoteId, Patient p) async {}

  @override
  Future<List<Patient>> fetchAll() async => List.of(stored);
}

class _OfflineRemote implements PatientRemote {
  @override
  Future<int> create(Patient p) async => throw const NetworkFailure();
  @override
  Future<void> update(int remoteId, Patient p) async => throw const NetworkFailure();
  @override
  Future<List<Patient>> fetchAll() async => throw const NetworkFailure();
}

void main() {
  test('envía las fichas pendientes y descarga las nuevas', () async {
    final local = InMemoryPatientRepository(); // 3 pendientes y 2 enviadas
    final result = await SyncPatients(local, _FakeRemote())();

    expect(result.pushed, 3);
    expect(result.pulled, 1);
    final all = await local.getAll();
    expect(all.length, 6);
    expect(all.every((p) => p.synced), isTrue);
    expect(all.where((p) => p.remoteId != null).length, 4);
  });

  test('sin conexión lanza NetworkFailure y no marca nada como enviado', () async {
    final local = InMemoryPatientRepository();
    await expectLater(
        SyncPatients(local, _OfflineRemote())(), throwsA(isA<NetworkFailure>()));
    final pending = (await local.getAll()).where((p) => !p.synced).length;
    expect(pending, 3);
  });
}
