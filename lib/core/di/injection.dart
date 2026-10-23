import "package:get_it/get_it.dart";

import "../../features/auth/data/repositories/auth_repository_impl.dart";
import "../../features/auth/domain/repositories/auth_repository.dart";
import "../../features/auth/domain/usecases/login_usecase.dart";
import "../../features/auth/presentation/bloc/auth_bloc.dart";

final getIt = GetIt.instance;

/// Registro de dependencias. Es seguro llamarlo más de una vez.
void setupDependencies() {
  if (getIt.isRegistered<AuthRepository>()) return;
  getIt
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl())
    ..registerLazySingleton(() => LoginUseCase(getIt()))
    ..registerFactory(() => AuthBloc(getIt()));
}
