import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('la app arranca en la pantalla de inicio de sesión', (tester) async {
    await pumpApp(tester);
    expect(find.text('Salud Movil IES'), findsOneWidget);
    expect(find.text('INGRESAR'), findsOneWidget);
  });
}
