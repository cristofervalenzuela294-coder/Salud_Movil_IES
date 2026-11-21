import 'push_service.dart';

/// Se usa donde FCM no existe (Windows, pruebas) para que la app no falle.
class NoopPushService implements PushService {
  @override
  bool get available => false;

  @override
  String? get token => null;

  @override
  Future<void> init() async {}

  @override
  Stream<PushMessage> get onForeground => const Stream.empty();

  @override
  Stream<PushMessage> get onOpened => const Stream.empty();

  @override
  PushMessage? takeInitialMessage() => null;
}
