import '../domain/entities/patient.dart';
import '../domain/entities/triage_level.dart';

/// Datos de ejemplo. En el Hito 7 se leen de SQLite.
const samplePatients = [
  Patient(name: 'Luis Q.', age: 67, reason: 'Dolor torácico', level: TriageLevel.i),
  Patient(name: 'Rosa M.', age: 54, reason: 'Dificultad respiratoria', level: TriageLevel.ii),
  Patient(name: 'Carlos P.', age: 31, reason: 'Fiebre de 3 días', level: TriageLevel.iii),
  Patient(name: 'Ana T.', age: 8, reason: 'Dolor de oído', level: TriageLevel.iv),
  Patient(name: 'Mario S.', age: 40, reason: 'Control de presión', level: TriageLevel.v),
];
