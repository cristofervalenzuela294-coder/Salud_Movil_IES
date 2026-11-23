import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('abre el detalle de una ficha con su nivel de prioridad', (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);

    await tester.tap(find.text('Luis Q.'));
    await tester.pumpAndSettle();

    expect(find.text('Ficha de Luis Q.'), findsOneWidget);
    expect(find.text('NIVEL I · Inmediato'), findsOneWidget);
    expect(find.text('EDITAR'), findsOneWidget);
    expect(find.text('ELIMINAR'), findsOneWidget);
  });

  testWidgets('eliminar una ficha pide confirmación y la quita de la lista',
      (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);
    await tester.tap(find.text('Luis Q.'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ELIMINAR'));
    await tester.pumpAndSettle();
    expect(find.text('Eliminar ficha'), findsOneWidget); // diálogo de confirmación

    await tester.tap(find.widgetWithText(TextButton, 'ELIMINAR'));
    await tester.pumpAndSettle();

    expect(find.text('Pacientes en espera'), findsOneWidget);
    expect(find.text('Luis Q.'), findsNothing);
    expect(find.text('Ficha eliminada'), findsOneWidget);
  });
}
