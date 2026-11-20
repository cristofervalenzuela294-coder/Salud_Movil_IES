import 'package:equatable/equatable.dart';

import 'triage_level.dart';
import 'vital_signs.dart';

class Patient extends Equatable {
  const Patient({
    this.id,
    this.remoteId,
    required this.name,
    required this.age,
    required this.reason,
    required this.level,
    this.dni = '',
    this.vitals,
    this.synced = false,
  });
  final int? id;

  /// Identificador de la ficha en el servidor (null si nunca se envió).
  final int? remoteId;
  final String name;
  final int age;
  final String reason;
  final TriageLevel level;
  final String dni;
  final VitalSigns? vitals;
  final bool synced;

  Patient copyWith({
    int? id,
    int? remoteId,
    String? dni,
    String? name,
    int? age,
    String? reason,
    TriageLevel? level,
    VitalSigns? vitals,
    bool? synced,
  }) =>
      Patient(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        dni: dni ?? this.dni,
        name: name ?? this.name,
        age: age ?? this.age,
        reason: reason ?? this.reason,
        level: level ?? this.level,
        vitals: vitals ?? this.vitals,
        synced: synced ?? this.synced,
      );

  @override
  List<Object?> get props =>
      [id, remoteId, name, age, reason, level, dni, vitals, synced];
}
