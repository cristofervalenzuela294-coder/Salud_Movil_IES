import 'package:equatable/equatable.dart';

class PushMessage extends Equatable {
  const PushMessage({
    this.id,
    required this.title,
    required this.body,
    this.data = const {},
  });
  final String? id;
  final String title;
  final String body;
  final Map<String, String> data;

  @override
  List<Object?> get props => [id, title, body, data];
}

/// Contrato del servicio de notificaciones push.
abstract class PushService {
  /// Falso si la plataforma no soporta FCM o Firebase no está configurado.
  bool get available;
  String? get token;

  Future<void> init();

  /// Mensajes recibidos con la app abierta.
  Stream<PushMessage> get onForeground;

  /// Mensajes que el usuario tocó desde la bandeja del sistema.
  Stream<PushMessage> get onOpened;

  /// Mensaje que abrió la app estando cerrada (solo se entrega una vez).
  PushMessage? takeInitialMessage();
}
