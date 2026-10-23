import "package:equatable/equatable.dart";

import "triage_level.dart";

class Patient extends Equatable {
  const Patient({
    required this.name,
    required this.age,
    required this.reason,
    required this.level,
  });
  final String name;
  final int age;
  final String reason;
  final TriageLevel level;

  @override
  List<Object?> get props => [name, age, reason, level];
}
