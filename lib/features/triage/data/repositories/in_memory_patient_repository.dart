import '../../domain/entities/patient.dart';
import '../../domain/entities/vital_signs.dart';
import '../../domain/repositories/patient_repository.dart';
import '../../domain/usecases/triage_calculator.dart';

/// Implementación temporal en memoria. Se reemplaza por SQLite en el Hito 6.
class InMemoryPatientRepository implements PatientRepository {
  InMemoryPatientRepository() {
    const calc = TriageCalculator();
    Patient seed(String name, int age, String reason, VitalSigns v, bool synced) =>
        Patient(
          name: name,
          age: age,
          reason: reason,
          level: calc.evaluate(v).level,
          vitals: v,
          synced: synced,
        );
    _items.addAll([
      seed('Luis Q.', 67, 'Dolor torácico',
          const VitalSigns(systolic: 150, diastolic: 95, spo2: 84, heartRate: 120, pain: 8), false),
      seed('Rosa M.', 54, 'Dificultad respiratoria',
          const VitalSigns(systolic: 150, diastolic: 95, spo2: 89, heartRate: 112, pain: 6), false),
      seed('Carlos P.', 31, 'Fiebre de 3 días',
          const VitalSigns(systolic: 125, diastolic: 80, spo2: 96, heartRate: 118, pain: 3), false),
      seed('Ana T.', 8, 'Dolor de oído',
          const VitalSigns(systolic: 100, diastolic: 65, spo2: 98, heartRate: 105, pain: 4), true),
      seed('Mario S.', 40, 'Control de presión',
          const VitalSigns(systolic: 130, diastolic: 85, spo2: 98, heartRate: 80, pain: 1), true),
    ]);
  }

  final List<Patient> _items = [];

  @override
  Future<List<Patient>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> add(Patient patient) async => _items.add(patient);

  @override
  Future<void> markAllSynced() async {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(synced: true);
    }
  }
}
