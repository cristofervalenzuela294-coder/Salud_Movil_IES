import '../../domain/entities/patient.dart';
import '../../domain/entities/triage_level.dart';
import '../../domain/entities/vital_signs.dart';

/// Conversión entre la entidad [Patient] y una fila de la tabla `patients`.
class PatientModel {
  static Map<String, Object?> toMap(Patient p) => {
        if (p.id != null) 'id': p.id,
        'dni': p.dni,
        'name': p.name,
        'age': p.age,
        'reason': p.reason,
        'level': p.level.index,
        'systolic': p.vitals?.systolic,
        'diastolic': p.vitals?.diastolic,
        'spo2': p.vitals?.spo2,
        'heart_rate': p.vitals?.heartRate,
        'pain': p.vitals?.pain,
        'synced': p.synced ? 1 : 0,
      };

  static Patient fromMap(Map<String, Object?> m) {
    final hasVitals = m['systolic'] != null;
    return Patient(
      id: m['id'] as int?,
      dni: m['dni'] as String,
      name: m['name'] as String,
      age: m['age'] as int,
      reason: m['reason'] as String,
      level: TriageLevel.values[m['level'] as int],
      synced: (m['synced'] as int) == 1,
      vitals: hasVitals
          ? VitalSigns(
              systolic: m['systolic'] as int,
              diastolic: m['diastolic'] as int,
              spo2: m['spo2'] as int,
              heartRate: m['heart_rate'] as int,
              pain: m['pain'] as int,
            )
          : null,
    );
  }
}
