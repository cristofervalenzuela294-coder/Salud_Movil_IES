import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('el formulario de admisión valida los datos', (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);
    await tester.tap(find.text('+ NUEVO PACIENTE'));
    await tester.pumpAndSettle();

    await enterFields(tester, ['1234', '', '150', '']);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pump();

    expect(find.text('El DNI debe tener 8 dígitos'), findsOneWidget);
    expect(find.text('El nombre: campo obligatorio'), findsOneWidget);
    expect(find.text('La edad debe estar entre 0 y 120 años'), findsOneWidget);
    expect(find.text('Signos vitales'), findsNothing); // no avanza
  });

  testWidgets('los signos vitales fuera de rango se rechazan', (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);
    await tester.tap(find.text('+ NUEVO PACIENTE'));
    await tester.pumpAndSettle();
    await enterFields(
        tester, ['12345678', 'Paciente Prueba', '30', 'Dolor de cabeza']);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    await enterFields(tester, ['80/120', '101', '']);
    await tester.tap(find.text('CALCULAR PRIORIDAD'));
    await tester.pump();

    expect(find.text('La sistólica debe ser mayor que la diastólica'),
        findsOneWidget);
    expect(
        find.text('La saturación debe estar entre 50 y 100 %'), findsOneWidget);
    expect(find.text('La frecuencia: campo obligatorio'), findsOneWidget);
    expect(find.text('Resultado de triage'), findsNothing);
  });

  testWidgets('flujo completo: registrar, calcular prioridad y guardar',
      (tester) async {
    await pumpApp(tester);
    await loginAsNurse(tester);

    await tester.tap(find.text('+ NUEVO PACIENTE'));
    await tester.pumpAndSettle();
    await enterFields(
        tester, ['12345678', 'Paciente Prueba', '30', 'Dolor de cabeza']);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    expect(find.text('Signos vitales'), findsOneWidget);
    expect(find.text('Paciente Prueba · 30 años'), findsOneWidget);

    await enterFields(tester, ['120/80', '98', '75']);
    await tester.tap(find.text('CALCULAR PRIORIDAD'));
    await tester.pumpAndSettle();

    expect(find.text('NIVEL V'), findsOneWidget);
    expect(find.text('No urgente'), findsOneWidget);

    await tester.tap(find.text('GUARDAR FICHA'));
    await tester.pumpAndSettle();

    expect(find.text('Pacientes en espera'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Paciente Prueba'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Paciente Prueba'), findsOneWidget);
  });
}
