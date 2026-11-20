import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/auth_session.dart';
import '../../../../core/network/dio_failure.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Inicio de sesión contra la API REST (`POST /auth/login`).
///
/// Si no hay conexión con el servidor, se permite un ingreso local sin token
/// (modo offline del prototipo): se puede trabajar, pero no sincronizar.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._session);
  final Dio _dio;
  final AuthSession _session;

  @override
  Future<AppUser> login(String username, String password) async {
    try {
      final res = await _dio.post('/auth/login',
          data: {'username': username, 'password': password});
      final data = res.data as Map<String, dynamic>;
      _session.token = data['token'] as String?;
      final user = data['user'] as Map<String, dynamic>;
      return AppUser(
        username: user['username'] as String,
        role: _role(user['role'] as String?),
      );
    } on DioException catch (e) {
      final failure = failureFromDio(e);
      if (failure is NetworkFailure || failure is TimeoutFailure) {
        debugPrint('Login sin conexión: modo offline');
        _session.token = null;
        return AppUser(username: username, role: UserRole.enfermeria);
      }
      throw failure;
    }
  }

  UserRole _role(String? r) => switch (r) {
        'medico' => UserRole.medico,
        'paciente' => UserRole.paciente,
        _ => UserRole.enfermeria,
      };
}
