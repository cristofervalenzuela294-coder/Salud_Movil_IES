import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/utils/validators.dart';

void main() {
  group('DNI', () {
    test('acepta 8 dígitos', () => expect(Validators.dni('12345678'), isNull));
    test('rechaza vacío', () => expect(Validators.dni(''), isNotNull));
    test('rechaza longitud incorrecta', () => expect(Validators.dni('1234'), isNotNull));
  });

  group('Presión arterial', () {
    test('acepta 120/80', () => expect(Validators.bloodPressure('120/80'), isNull));
    test('acepta espacios', () => expect(Validators.bloodPressure('150 / 95'), isNull));
    test('rechaza formato', () => expect(Validators.bloodPressure('12080'), isNotNull));
    test('rechaza sistólica menor', () => expect(Validators.bloodPressure('80/120'), isNotNull));
  });

  group('Rangos numéricos', () {
    String? spo2(String? v) =>
        Validators.intInRange(v, field: 'La saturación', min: 50, max: 100);
    test('acepta 95', () => expect(spo2('95'), isNull));
    test('rechaza 101', () => expect(spo2('101'), isNotNull));
    test('rechaza texto', () => expect(spo2('abc'), isNotNull));
  });

  group('Nombre', () {
    test('acepta letras', () => expect(Validators.fullName('María Pérez'), isNull));
    test('rechaza números', () => expect(Validators.fullName('Ana 2'), isNotNull));
  });
}
