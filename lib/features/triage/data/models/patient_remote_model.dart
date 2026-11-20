import '../../domain/entities/patient.dart';
import '../../domain/entities/triage_level.dart';
import '../../domain/entities/vital_signs.dart';

/// Conversión entre [Patient] y el JSON de la API REST.
class PatientRemoteModel {
  static Map<String, dynamic> toJson(Patient p) => {
        'dni': p.dni,
        'name': p.name,
        'age': p.age,
        'reason': p.reason,
        'level': p.level.roman,
        'systolic': p.vitals?.systolic,
        'diastolic': p.vitals?.diastolic,
        'spo2': p.vitals?.spo2,
        'heartRate': p.vitals?.heartRate,
        'pain': p.vitals?.pain,
      };

  static Patient fromJson(Map<String, dynamic> j) {
    final hasVitals = j['systolic'] != null;
    return Patient(
      remoteId: (j['id'] as num).toInt(),
      dni: (j['dni'] as String?) ?? '',
      name: j['name'] as String,
      age: (j['age'] as num).toInt(),
      reason: (j['reason'] as String?) ?? '',
      level: TriageLevel.values.firstWhere((l) => l.roman == j['level']),
      synced: true,
      vitals: hasVitals
          ? VitalSigns(
              systolic: (j['systolic'] as num).toInt(),
              diastolic: (j['diastolic'] as num).toInt(),
              spo2: (j['spo2'] as num).toInt(),
              heartRate: (j['heartRate'] as num).toInt(),
              pain: (j['pain'] as num).toInt(),
            )
          : null,
    );
  }
}
