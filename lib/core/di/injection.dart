import 'package:get_it/get_it.dart';

import '../../features/appointments/presentation/cubit/appointments_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/triage/data/repositories/in_memory_patient_repository.dart';
import '../../features/triage/domain/repositories/patient_repository.dart';
import '../../features/triage/domain/usecases/triage_calculator.dart';
import '../../features/triage/presentation/bloc/patients_bloc.dart';
import '../../features/triage/presentation/bloc/triage_bloc.dart';

final getIt = GetIt.instance;

/// Registro de dependencias. Es seguro llamarlo más de una vez.
void setupDependencies() {
  if (getIt.isRegistered<AuthRepository>()) return;
  getIt
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl())
    ..registerLazySingleton(() => LoginUseCase(getIt()))
    ..registerFactory(() => AuthBloc(getIt()))
    ..registerLazySingleton<PatientRepository>(() => InMemoryPatientRepository())
    ..registerLazySingleton(() => const TriageCalculator())
    ..registerFactory(() => PatientsBloc(getIt()))
    ..registerFactory(() => TriageBloc(getIt()))
    ..registerFactory(() => AppointmentsCubit());
}
