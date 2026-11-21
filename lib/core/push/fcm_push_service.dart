import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'push_service.dart';

/// Se ejecuta en un aislamiento aparte cuando llega un mensaje con la app en segundo plano.
/// Los mensajes con `notification` los muestra el sistema automáticamente.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM en segundo plano: ${message.messageId}');
}

class FcmPushService implements PushService {
  final _foreground = StreamController<PushMessage>.broadcast();
  final _opened = StreamController<PushMessage>.broadcast();
  bool _available = false;
  String? _token;
  PushMessage? _initial;

  @override
  bool get available => _available;

  @override
  String? get token => _token;

  @override
  Stream<PushMessage> get onForeground => _foreground.stream;

  @override
  Stream<PushMessage> get onOpened => _opened.stream;

  @override
  PushMessage? takeInitialMessage() {
    final m = _initial;
    _initial = null;
    return m;
  }

  PushMessage _map(RemoteMessage m) => PushMessage(
        id: m.messageId,
        title: m.notification?.title ?? m.data['title']?.toString() ?? 'Aviso',
        body: m.notification?.body ?? m.data['body']?.toString() ?? '',
        data: m.data.map((k, v) => MapEntry(k, v.toString())),
      );

  @override
  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(); // Android 13+ pide permiso en pantalla
      _token = await messaging.getToken().timeout(const Duration(seconds: 10));
      debugPrint('FCM token: $_token');
      messaging.onTokenRefresh.listen((t) => _token = t);

      FirebaseMessaging.onMessage.listen((m) => _foreground.add(_map(m)));
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _opened.add(_map(m)));

      final initial = await messaging.getInitialMessage();
      if (initial != null) _initial = _map(initial);

      _available = true;
    } catch (e) {
      debugPrint('FCM no disponible: $e');
      _available = false;
    }
  }
}
