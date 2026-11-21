import 'dart:io';

import 'package:flutter/foundation.dart';

/// FCM solo funciona en Android e iOS (no en Windows, Linux ni pruebas).
bool get pushSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
