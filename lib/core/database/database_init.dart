import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// En Android e iOS sqflite funciona de forma nativa.
/// En Windows, Linux y macOS se usa la implementación FFI (para desarrollar en PC).
void initDatabaseFactory() {
  if (kIsWeb) return;
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
