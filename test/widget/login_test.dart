import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('muestra errores si los campos están vacíos', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('INGRESAR'));
    await tester.pump();

    expect(find.text('El usuario: campo obligatorio'), findsOneWidget);
    expect(find.text('La contraseña: campo obligatorio'), findsOneWidget);
    expect(find.text('Pacientes en espera'), findsNothing);
  });

  testWidgets('rechaza una contraseña demasiado corta', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'enfermera');
    await tester.enterText(find.byType(TextFormField).at(1), '12');
    await tester.tap(find.text('INGRESAR'));
    await tester.pump();

    expect(find.text('La contraseña debe tener al menos 4 caracteres'), findsOneWidget);
  });

  testWidgets('con datos válidos entra a Pacientes en espera', (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);

    expect(find.text('Pacientes en espera'), findsOneWidget);
    expect(find.text('Luis Q.'), findsOneWidget); // paciente de mayor prioridad
    expect(find.text('+ NUEVO PACIENTE'), findsOneWidget);
  });
}
