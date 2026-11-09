import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/database/app_database.dart';
import 'package:saludmovil_ies/features/appointments/data/repositories/in_memory_appointment_repository.dart';
import 'package:saludmovil_ies/features/appointments/domain/entities/appointment.dart';
import 'package:saludmovil_ies/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:saludmovil_ies/features/triage/data/datasources/patient_dao.dart';
import 'package:saludmovil_ies/features/triage/data/repositories/in_memory_patient_repository.dart';
import 'package:saludmovil_ies/features/triage/data/repositories/sqlite_patient_repository.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/patient.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/triage_level.dart';
import 'package:saludmovil_ies/features/triage/presentation/bloc/patients_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('PatientsBloc: editar y eliminar una ficha', () async {
    final bloc = PatientsBloc(InMemoryPatientRepository());
    final s0 = await bloc.stream.firstWhere((s) => !s.loading);
    final p = s0.patients.first;

    bloc.add(PatientUpdated(p.copyWith(name: 'Cambiado')));
    final s1 = await bloc.stream
        .firstWhere((s) => s.patients.any((x) => x.name == 'Cambiado'));
    expect(s1.selected?.name, 'Cambiado');

    bloc.add(PatientDeleted(s1.selected!));
    final s2 = await bloc.stream.firstWhere((s) => s.patients.length == 4);
    expect(s2.selected, isNull);
    await bloc.close();
  });

  test('SqlitePatientRepository: crear, leer, actualizar y eliminar', () async {
    final db = await AppDatabase.open(path: inMemoryDatabasePath);
    final repo = SqlitePatientRepository(PatientDao(db));

    await repo.add(const Patient(
        name: 'Prueba',
        age: 20,
        reason: 'Control',
        level: TriageLevel.v,
        dni: '11111111'));
    var all = await repo.getAll();
    expect(all.length, 1);

    await repo.update(all.first.copyWith(name: 'Editado', synced: true));
    all = await repo.getAll();
    expect(all.first.name, 'Editado');
    expect(all.first.synced, isTrue);

    await repo.delete(all.first.id!);
    expect(await repo.getAll(), isEmpty);
    await db.close();
  });

  test('AppointmentsCubit: agendar, editar y cancelar', () async {
    final cubit = AppointmentsCubit(InMemoryAppointmentRepository());
    await cubit.load();
    expect(cubit.state.length, 2);

    await cubit.add(const Appointment(
        specialty: 'Odontología',
        sede: 'Sede Principal',
        date: '10/11/2026',
        time: '11:00'));
    expect(cubit.state.length, 3);

    final last = cubit.state.last;
    await cubit.update(last.copyWith(time: '12:30'));
    expect(cubit.state.last.time, '12:30');

    await cubit.delete(last.id!);
    expect(cubit.state.length, 2);
    await cubit.close();
  });
}
