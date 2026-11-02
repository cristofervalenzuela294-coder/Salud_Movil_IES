import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/features/triage/data/repositories/in_memory_patient_repository.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/patient.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/triage_level.dart';
import 'package:saludmovil_ies/features/triage/presentation/bloc/patients_bloc.dart';

void main() {
  test('carga pacientes ordenados por prioridad', () async {
    final bloc = PatientsBloc(InMemoryPatientRepository());
    final s = await bloc.stream.firstWhere((s) => !s.loading);
    expect(s.patients.length, 5);
    final levels = s.patients.map((p) => p.level.index).toList();
    expect(levels, [...levels]..sort());
    await bloc.close();
  });

  test('guardar ficha la agrega como pendiente', () async {
    final bloc = PatientsBloc(InMemoryPatientRepository());
    await bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const PatientSaved(Patient(
        name: 'Nuevo P.', age: 30, reason: 'Control', level: TriageLevel.v)));
    final s = await bloc.stream.firstWhere((s) => s.patients.length == 6);
    expect(s.pending, 4);
    await bloc.close();
  });

  test('sincronizar deja 0 pendientes', () async {
    final bloc = PatientsBloc(InMemoryPatientRepository());
    await bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const SyncRequested());
    final s = await bloc.stream.firstWhere((s) => !s.syncing && s.pending == 0);
    expect(s.pending, 0);
    await bloc.close();
  });
}
