import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/error/failures.dart';
import 'package:saludmovil_ies/features/auth/domain/entities/app_user.dart';
import 'package:saludmovil_ies/features/auth/domain/repositories/auth_repository.dart';
import 'package:saludmovil_ies/features/auth/domain/usecases/login_usecase.dart';
import 'package:saludmovil_ies/features/auth/presentation/bloc/auth_bloc.dart';

class _Repo implements AuthRepository {
  _Repo({this.error});
  final Object? error;

  @override
  Future<AppUser> login(String username, String password) async {
    if (error != null) throw error!;
    return AppUser(username: username, role: UserRole.medico);
  }
}

void main() {
  test('login correcto: Loading y luego Success', () async {
    final bloc = AuthBloc(LoginUseCase(_Repo()));
    expectLater(bloc.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthSuccess>()]));
    bloc.add(const LoginSubmitted('medico', '1234'));
  });

  test('datos vacíos: falla sin llamar al repositorio', () async {
    final bloc = AuthBloc(LoginUseCase(_Repo()));
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        isA<AuthFailure>()
            .having((s) => s.message, 'message', 'Ingrese usuario y contraseña'),
      ]),
    );
    bloc.add(const LoginSubmitted('', ''));
  });

  test('credenciales incorrectas: muestra el mensaje del servidor', () async {
    final bloc = AuthBloc(LoginUseCase(
        _Repo(error: const UnauthorizedFailure('Usuario o contraseña incorrectos'))));
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        isA<AuthFailure>().having(
            (s) => s.message, 'message', 'Usuario o contraseña incorrectos'),
      ]),
    );
    bloc.add(const LoginSubmitted('medico', 'mala'));
  });
}
