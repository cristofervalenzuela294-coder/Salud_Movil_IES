import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/error/failures.dart';
import 'package:saludmovil_ies/core/network/dio_failure.dart';

DioException _error(DioExceptionType type, {int? status, Object? data}) {
  final req = RequestOptions(path: '/x');
  return DioException(
    requestOptions: req,
    type: type,
    response: status == null
        ? null
        : Response(requestOptions: req, statusCode: status, data: data),
  );
}

void main() {
  test('timeout -> TimeoutFailure', () {
    expect(failureFromDio(_error(DioExceptionType.receiveTimeout)),
        isA<TimeoutFailure>());
  });

  test('sin conexión -> NetworkFailure', () {
    expect(failureFromDio(_error(DioExceptionType.connectionError)),
        isA<NetworkFailure>());
  });

  test('401 -> UnauthorizedFailure con el mensaje del servidor', () {
    final f = failureFromDio(_error(DioExceptionType.badResponse,
        status: 401, data: {'error': 'Sesión no válida'}));
    expect(f, isA<UnauthorizedFailure>());
    expect(f.message, 'Sesión no válida');
  });

  test('400 -> ServerFailure con el mensaje del servidor', () {
    final f = failureFromDio(_error(DioExceptionType.badResponse,
        status: 400, data: {'error': 'Nombre inválido'}));
    expect(f, isA<ServerFailure>());
    expect(f.message, 'Nombre inválido');
  });

  test('500 -> ServerFailure genérico', () {
    final f = failureFromDio(_error(DioExceptionType.badResponse, status: 500));
    expect(f, isA<ServerFailure>());
    expect((f as ServerFailure).statusCode, 500);
  });
}
