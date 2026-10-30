/// Validadores reutilizables para los formularios.
/// Devuelven `null` si el valor es válido, o el mensaje de error.
class Validators {
  static String? required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field es obligatorio';
    return null;
  }

  static String? minLength(String? v, int min, String field) {
    final e = required(v, field);
    if (e != null) return e;
    if (v!.trim().length < min) return '$field debe tener al menos $min caracteres';
    return null;
  }

  static String? dni(String? v) {
    final e = required(v, 'El DNI');
    if (e != null) return e;
    if (!RegExp(r'^\d{8}$').hasMatch(v!.trim())) {
      return 'El DNI debe tener 8 dígitos';
    }
    return null;
  }

  static String? fullName(String? v) {
    final e = required(v, 'El nombre');
    if (e != null) return e;
    final t = v!.trim();
    if (t.length < 3) return 'Ingrese al menos 3 letras';
    if (!RegExp(r'^[A-Za-zÁÉÍÓÚÜáéíóúüÑñ ]+$').hasMatch(t)) {
      return 'Use solo letras y espacios';
    }
    return null;
  }

  static String? intInRange(
    String? v, {
    required String field,
    required int min,
    required int max,
    String unit = '',
  }) {
    final e = required(v, field);
    if (e != null) return e;
    final n = int.tryParse(v!.trim());
    if (n == null) return '$field debe ser un número entero';
    if (n < min || n > max) return '$field debe estar entre $min y $max$unit';
    return null;
  }

  /// Formato "120/80" (sistólica/diastólica en mmHg).
  static String? bloodPressure(String? v) {
    final e = required(v, 'La presión');
    if (e != null) return e;
    final m = RegExp(r'^(\d{2,3})\s*/\s*(\d{2,3})$').firstMatch(v!.trim());
    if (m == null) return 'Use el formato 120/80';
    final sys = int.parse(m.group(1)!);
    final dia = int.parse(m.group(2)!);
    if (sys < 60 || sys > 260) return 'Sistólica fuera de rango (60 a 260)';
    if (dia < 30 || dia > 160) return 'Diastólica fuera de rango (30 a 160)';
    if (sys <= dia) return 'La sistólica debe ser mayor que la diastólica';
    return null;
  }
}
