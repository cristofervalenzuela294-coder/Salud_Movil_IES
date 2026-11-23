import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/app.dart';
import 'package:saludmovil_ies/core/di/injection.dart';
import 'package:saludmovil_ies/core/push/push_service.dart';
import 'package:saludmovil_ies/core/router/app_router.dart';
import 'package:saludmovil_ies/features/auth/domain/entities/app_user.dart';
import 'package:saludmovil_ies/features/auth/domain/repositories/auth_repository.dart';

/// Autenticación simulada: así las pruebas no dependen del servidor.
class FakeAuthRepository implements AuthRepository {
  @override
  Future<AppUser> login(String username, String password) async =>
      AppUser(username: username, role: UserRole.enfermeria);
}

/// Push simulado para probar la pantalla de avisos sin Firebase.
class FakePushService implements PushService {
  final foreground = StreamController<PushMessage>.broadcast();
  final opened = StreamController<PushMessage>.broadcast();

  @override
  bool get available => true;
  @override
  String? get token => 'token-de-prueba';
  @override
  Future<void> init() async {}
  @override
  Stream<PushMessage> get onForeground => foreground.stream;
  @override
  Stream<PushMessage> get onOpened => opened.stream;
  @override
  PushMessage? takeInitialMessage() => null;
}

/// Arranca la app completa con datos en memoria, en una pantalla tipo celular.
Future<void> pumpApp(WidgetTester tester, {PushService? push}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await getIt.reset();
  await setupDependencies(inMemory: true);
  getIt.unregister<AuthRepository>();
  getIt.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
  if (push != null) {
    getIt.unregister<PushService>();
    getIt.registerLazySingleton<PushService>(() => push);
  }

  await tester.pumpWidget(const SaludMovilApp());
  appRouter.go('/'); // el router es global: se reinicia en cada prueba
  await tester.pumpAndSettle();
}

Future<void> loginAsNurse(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'enfermera');
  await tester.enterText(fields.at(1), '1234');
  await tester.tap(find.text('INGRESAR'));
  await tester.pumpAndSettle();
}

/// Escribe [values] en los campos de texto visibles, en orden.
Future<void> enterFields(WidgetTester tester, List<String> values) async {
  for (var i = 0; i < values.length; i++) {
    await tester.enterText(find.byType(TextFormField).at(i), values[i]);
  }
  await tester.pump();
}
