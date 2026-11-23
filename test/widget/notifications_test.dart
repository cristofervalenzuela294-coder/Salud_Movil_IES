import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/push/push_service.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('una notificación push aparece en la lista de avisos', (tester) async {
    final push = FakePushService();
    await pumpApp(tester, push: push);
    await loginAsNurse(tester);

    await tester.tap(find.text('Avisos'));
    await tester.pumpAndSettle();
    expect(find.text('Push activas'), findsOneWidget);
    expect(find.text('COPIAR TOKEN FCM'), findsOneWidget);
    expect(find.text('Aún no hay avisos'), findsOneWidget);

    push.foreground.add(const PushMessage(
      id: 'm1',
      title: 'Pase al consultorio 3',
      body: 'Rosa M., diríjase ahora',
      data: {'type': 'call'},
    ));
    await tester.pumpAndSettle();

    expect(find.text('Pase al consultorio 3'), findsOneWidget);
    expect(find.text('Llamado'), findsOneWidget);
    expect(find.text('Aún no hay avisos'), findsNothing);
  });
}
