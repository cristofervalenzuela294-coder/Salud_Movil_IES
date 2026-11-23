import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('lista las citas y permite cancelar una', (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);

    await tester.tap(find.text('Citas'));
    await tester.pumpAndSettle();
    expect(find.text('Mis citas'), findsOneWidget);
    expect(find.text('Medicina general'), findsOneWidget);
    expect(find.text('Pediatría'), findsOneWidget);

    await tester.tap(find.text('Medicina general'));
    await tester.pumpAndSettle();
    expect(find.text('Editar cita'), findsOneWidget);

    await tester.tap(find.text('Cancelar cita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SÍ, CANCELAR'));
    await tester.pumpAndSettle();

    expect(find.text('Medicina general'), findsNothing);
    expect(find.text('Pediatría'), findsOneWidget);
    expect(find.text('Cita cancelada'), findsOneWidget);
  });
}
