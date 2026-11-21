import 'package:dio/dio.dart';
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
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/sedes/presentation/cubit/location_cubit.dart';
import '../../features/triage/data/datasources/patient_dao.dart';
import '../../features/triage/data/datasources/patient_remote_data_source.dart';
import '../../features/triage/data/repositories/in_memory_patient_repository.dart';
import '../../features/triage/data/repositories/sqlite_patient_repository.dart';
import '../../features/triage/domain/repositories/patient_remote.dart';
import '../../features/triage/domain/repositories/patient_repository.dart';
import '../../features/triage/domain/usecases/sync_patients.dart';
import '../../features/triage/domain/usecases/triage_calculator.dart';
import '../../features/triage/presentation/bloc/patients_bloc.dart';
import '../../features/triage/presentation/bloc/triage_bloc.dart';
import '../database/app_database.dart';
import '../location/geolocator_location_service.dart';
import '../location/location_service.dart';
import '../network/api_client.dart';
import '../network/auth_session.dart';
import '../push/fcm_push_service.dart';
import '../push/noop_push_service.dart';
import '../push/push_service.dart';
import '../push/push_support.dart';

final getIt = GetIt.instance;

/// Registro de dependencias. Es seguro llamarlo más de una vez.
/// Con [inMemory] = true no se abre SQLite (útil en pruebas de interfaz).
Future<void> setupDependencies({bool inMemory = false}) async {
  if (getIt.isRegistered<AuthRepository>()) return;

  getIt
    ..registerLazySingleton(() => AuthSession())
    ..registerLazySingleton<Dio>(() => createDio(getIt()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt(), getIt()))
    ..registerLazySingleton(() => LoginUseCase(getIt()))
    ..registerFactory(() => AuthBloc(getIt()))
    ..registerLazySingleton(() => const TriageCalculator())
    ..registerLazySingleton<PatientRemote>(() => PatientRemoteDataSource(getIt()))
    ..registerLazySingleton<LocationService>(() => GeolocatorLocationService())
    ..registerLazySingleton<PushService>(
        () => pushSupported ? FcmPushService() : NoopPushService());

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
    ..registerLazySingleton(() => SyncPatients(getIt(), getIt()))
    ..registerFactory(() => PatientsBloc(getIt(), sync: getIt<SyncPatients>()))
    ..registerFactory(() => TriageBloc(getIt()))
    ..registerFactory(() => AppointmentsCubit(getIt()))
    ..registerFactory(() => LocationCubit(getIt()))
    ..registerFactory(() => NotificationsCubit(getIt()));
}
