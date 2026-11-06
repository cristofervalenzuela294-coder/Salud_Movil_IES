import 'package:equatable/equatable.dart';

import 'triage_level.dart';
import 'vital_signs.dart';

class Patient extends Equatable {
  const Patient({
    this.id,
    required this.name,
    required this.age,
    required this.reason,
    required this.level,
    this.dni = '',
    this.vitals,
    this.synced = false,
  });
  final int? id;
  final String name;
  final int age;
  final String reason;
  final TriageLevel level;
  final String dni;
  final VitalSigns? vitals;
  final bool synced;

  Patient copyWith({int? id, bool? synced}) => Patient(
        id: id ?? this.id,
        name: name,
        age: age,
        reason: reason,
        level: level,
        dni: dni,
        vitals: vitals,
        synced: synced ?? this.synced,
      );

  @override
  List<Object?> get props => [id, name, age, reason, level, dni, vitals, synced];
}
