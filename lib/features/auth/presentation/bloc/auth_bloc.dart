import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../domain/entities/app_user.dart";
import "../../domain/usecases/login_usecase.dart";

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted(this.username, this.password);
  final String username;
  final String password;
  @override
  List<Object?> get props => [username, password];
}

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final AppUser user;
  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  const AuthFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._login) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLogin);
  }

  final LoginUseCase _login;

  Future<void> _onLogin(LoginSubmitted e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      emit(AuthSuccess(await _login(e.username, e.password)));
    } on ArgumentError catch (err) {
      emit(AuthFailure(err.message.toString()));
    } catch (_) {
      emit(const AuthFailure("No se pudo iniciar sesión"));
    }
  }
}
