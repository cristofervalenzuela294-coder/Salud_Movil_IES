import '../entities/triage_assessment.dart';
import '../entities/triage_level.dart';
import '../entities/vital_signs.dart';

/// Reglas de prioridad del triage (lógica de negocio pura, sin Flutter).
///
/// IMPORTANTE: los rangos son una propuesta académica para adultos.
/// Deben confirmarse con el docente (escala MINSA o Manchester).
/// El nivel final es el más grave entre todos los signos evaluados.
class TriageCalculator {
  const TriageCalculator();

  TriageAssessment evaluate(VitalSigns v) {
    final pressure = _pressure(v);
    final findings = [
      pressure,
      VitalFinding('SpO₂', '${v.spo2} %', v.spo2 < 95 ? 'Baja' : 'Normal', _spo2(v.spo2)),
      VitalFinding('Frec. cardíaca', '${v.heartRate} lpm', _hrFlag(v.heartRate),
          _heartRate(v.heartRate)),
      VitalFinding('Dolor', '${v.pain} / 10', _painFlag(v.pain), _pain(v.pain)),
    ];
    final worst = findings
        .map((f) => f.level)
        .reduce((a, b) => a.index <= b.index ? a : b);
    return TriageAssessment(v, worst, findings);
  }

  TriageLevel _spo2(int s) {
    if (s < 85) return TriageLevel.i;
    if (s <= 90) return TriageLevel.ii;
    if (s <= 94) return TriageLevel.iii;
    return TriageLevel.v;
  }

  TriageLevel _heartRate(int h) {
    if (h < 40 || h > 150) return TriageLevel.i;
    if (h < 50 || h > 130) return TriageLevel.ii;
    if (h < 60 || h > 110) return TriageLevel.iii;
    if (h > 100) return TriageLevel.iv;
    return TriageLevel.v;
  }

  TriageLevel _pain(int p) {
    if (p >= 9) return TriageLevel.ii;
    if (p >= 7) return TriageLevel.iii;
    if (p >= 4) return TriageLevel.iv;
    return TriageLevel.v;
  }

  VitalFinding _pressure(VitalSigns v) {
    final s = v.systolic;
    final d = v.diastolic;
    TriageLevel sys;
    if (s < 70 || s >= 220) {
      sys = TriageLevel.i;
    } else if (s < 90 || s >= 180) {
      sys = TriageLevel.ii;
    } else if (s < 100 || s >= 160) {
      sys = TriageLevel.iii;
    } else if (s >= 140) {
      sys = TriageLevel.iv;
    } else {
      sys = TriageLevel.v;
    }
    TriageLevel dia;
    if (d >= 120 || d < 40) {
      dia = TriageLevel.ii;
    } else if (d >= 110) {
      dia = TriageLevel.iii;
    } else if (d >= 90) {
      dia = TriageLevel.iv;
    } else {
      dia = TriageLevel.v;
    }
    final level = sys.index <= dia.index ? sys : dia;
    final flag = (s >= 140 || d >= 90) ? 'Elevada' : (s < 90 ? 'Baja' : 'Normal');
    return VitalFinding('Presión', '$s/$d', flag, level);
  }

  String _hrFlag(int h) => h < 60 ? 'Baja' : (h > 100 ? 'Alta' : 'Normal');

  String _painFlag(int p) => p >= 7 ? 'Intenso' : (p >= 4 ? 'Moderado' : 'Leve');
}
