import 'package:equatable/equatable.dart';

import 'triage_level.dart';
import 'vital_signs.dart';

/// Resultado de evaluar un signo vital individual.
class VitalFinding extends Equatable {
  const VitalFinding(this.name, this.value, this.flag, this.level);
  final String name;
  final String value;
  final String flag;
  final TriageLevel level;

  @override
  List<Object?> get props => [name, value, flag, level];
}

class TriageAssessment extends Equatable {
  const TriageAssessment(this.vitals, this.level, this.findings);
  final VitalSigns vitals;
  final TriageLevel level;
  final List<VitalFinding> findings;

  @override
  List<Object?> get props => [vitals, level, findings];
}
