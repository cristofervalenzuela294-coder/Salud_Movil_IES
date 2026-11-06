import 'package:flutter/material.dart';

import 'app.dart';
import 'core/database/database_init.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();
  await setupDependencies();
  runApp(const SaludMovilApp());
}
