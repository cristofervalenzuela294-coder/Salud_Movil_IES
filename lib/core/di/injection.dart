import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/appointments/data/datasources/appointment_dao.dart';
import '../../features/appointments/data/repositories/in_memory_appointment_repository.dart';
import '../../features/appointments/data/repositories/sqlite_appointment_repository.dart';
import '../../features/appointments/domain/repositories/appointment_repository.dart';
import '../../features/appointments/presentation/cubit/appointments_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/triage/data/datasources/patient_dao.dart';
import '../../features/triage/data/repositories/in_memory_patient_repository.dart';
import '../../features/triage/data/repositories/sqlite_patient_repository.dart';
import '../../features/triage/domain/repositories/patient_repository.dart';
import '../../features/triage/domain/usecases/triage_calculator.dart';
import '../../features/triage/presentation/bloc/patients_bloc.dart';
import '../../features/triage/presentation/bloc/triage_bloc.dart';
import '../database/app_database.dart';

final getIt = GetIt.instance;

/// Registro de dependencias. Es seguro llamarlo más de una vez.
/// Con [inMemory] = true no se abre SQLite (útil en pruebas de interfaz).
Future<void> setupDependencies({bool inMemory = false}) async {
  if (getIt.isRegistered<AuthRepository>()) return;

  getIt
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl())
    ..registerLazySingleton(() => LoginUseCase(getIt()))
    ..registerFactory(() => AuthBloc(getIt()))
    ..registerLazySingleton(() => const TriageCalculator());

  if (inMemory) {
    getIt
      ..registerLazySingleton<PatientRepository>(() => InMemoryPatientRepository())
      ..registerLazySingleton<AppointmentRepository>(
          () => InMemoryAppointmentRepository());
  } else {
    final db = await AppDatabase.open();
    getIt.registerSingleton<Database>(db);

    final patients = SqlitePatientRepository(PatientDao(db));
    await patients.seedIfEmpty();
    final appointments = SqliteAppointmentRepository(AppointmentDao(db));
    await appointments.seedIfEmpty();

    getIt
      ..registerSingleton<PatientRepository>(patients)
      ..registerSingleton<AppointmentRepository>(appointments);
  }

  getIt
    ..registerFactory(() => PatientsBloc(getIt()))
    ..registerFactory(() => TriageBloc(getIt()))
    ..registerFactory(() => AppointmentsCubit(getIt()));
}
