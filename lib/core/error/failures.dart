/// Errores de negocio y de red, sin depender de ninguna librería HTTP.
abstract class Failure implements Exception {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Sin conexión con el servidor'])
      : super(message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('El servidor tardó demasiado en responder');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String? message])
      : super(message ?? 'Credenciales o sesión no válidas');
}

class ServerFailure extends Failure {
  const ServerFailure(this.statusCode, String message) : super(message);
  final int statusCode;
}

/// GPS apagado, permiso denegado o ubicación no disponible.
class LocationFailure extends Failure {
  const LocationFailure(super.message);
}
