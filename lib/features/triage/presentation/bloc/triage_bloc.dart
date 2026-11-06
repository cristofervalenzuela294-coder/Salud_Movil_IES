import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/patient_draft.dart';
import '../../domain/entities/triage_assessment.dart';
import '../../domain/entities/vital_signs.dart';
import '../../domain/usecases/triage_calculator.dart';

abstract class TriageEvent extends Equatable {
  const TriageEvent();
  @override
  List<Object?> get props => [];
}

class TriageDraftSaved extends TriageEvent {
  const TriageDraftSaved(this.draft);
  final PatientDraft draft;
  @override
  List<Object?> get props => [draft];
}

class TriageVitalsSubmitted extends TriageEvent {
  const TriageVitalsSubmitted(this.vitals);
  final VitalSigns vitals;
  @override
  List<Object?> get props => [vitals];
}

class TriageReset extends TriageEvent {
  const TriageReset();
}

class TriageState extends Equatable {
  const TriageState({this.draft, this.assessment});
  final PatientDraft? draft;
  final TriageAssessment? assessment;

  @override
  List<Object?> get props => [draft, assessment];
}

/// Controla el flujo de triage: admisión -> signos vitales -> resultado.
class TriageBloc extends Bloc<TriageEvent, TriageState> {
  TriageBloc(this._calculator) : super(const TriageState()) {
    on<TriageDraftSaved>((e, emit) => emit(TriageState(draft: e.draft)));
    on<TriageVitalsSubmitted>((e, emit) => emit(TriageState(
          draft: state.draft,
          assessment: _calculator.evaluate(e.vitals),
        )));
    on<TriageReset>((e, emit) => emit(const TriageState()));
  }

  final TriageCalculator _calculator;
}
