import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/triage_level.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/vital_signs.dart';
import 'package:saludmovil_ies/features/triage/domain/usecases/triage_calculator.dart';

void main() {
  const calc = TriageCalculator();
  VitalSigns v({int s = 120, int d = 80, int o = 98, int h = 75, int p = 0}) =>
      VitalSigns(systolic: s, diastolic: d, spo2: o, heartRate: h, pain: p);

  test('signos normales -> nivel V', () {
    expect(calc.evaluate(v()).level, TriageLevel.v);
  });

  test('SpO2 menor a 85 -> nivel I', () {
    expect(calc.evaluate(v(o: 80)).level, TriageLevel.i);
  });

  test('SpO2 89 -> nivel II', () {
    expect(calc.evaluate(v(o: 89)).level, TriageLevel.ii);
  });

  test('dolor intenso -> nivel III', () {
    expect(calc.evaluate(v(p: 7)).level, TriageLevel.iii);
  });

  test('se toma el signo más grave', () {
    final r = calc.evaluate(v(s: 150, d: 95, o: 89, h: 112, p: 6));
    expect(r.level, TriageLevel.ii);
    expect(r.findings.length, 4);
  });

  test('presión muy alta -> nivel I', () {
    expect(calc.evaluate(v(s: 230, d: 100)).level, TriageLevel.i);
  });
}
