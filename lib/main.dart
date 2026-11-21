import 'package:flutter/material.dart';

import 'app.dart';
import 'core/database/database_init.dart';
import 'core/di/injection.dart';
import 'core/push/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();
  await setupDependencies();
  await getIt<PushService>().init();
  runApp(const SaludMovilApp());
}
