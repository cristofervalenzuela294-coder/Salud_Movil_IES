import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _override = String.fromEnvironment('API_URL');

  /// URL del servidor. Se puede cambiar al ejecutar:
  /// `flutter run --dart-define=API_URL=http://192.168.1.50:3000`
  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    // El emulador de Android ve la PC en 10.0.2.2
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }
}
