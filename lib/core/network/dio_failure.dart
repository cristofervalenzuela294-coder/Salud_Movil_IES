import 'package:dio/dio.dart';

import '../error/failures.dart';

/// Traduce los errores de Dio a [Failure] con mensajes claros para el usuario.
Failure failureFromDio(DioException e) {
  final type = e.type;

  if (type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout) {
    return const TimeoutFailure();
  }
  if (type == DioExceptionType.connectionError) {
    return const NetworkFailure();
  }
  if (type == DioExceptionType.badResponse) {
    final code = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    final serverMessage = data is Map ? data['error']?.toString() : null;
    if (code == 401 || code == 403) return UnauthorizedFailure(serverMessage);
    if (code >= 500) return ServerFailure(code, 'Error del servidor ($code)');
    return ServerFailure(code, serverMessage ?? 'Solicitud no válida ($code)');
  }
  if (type == DioExceptionType.cancel) {
    return const NetworkFailure('Solicitud cancelada');
  }
  return const NetworkFailure('No se pudo conectar con el servidor');
}
