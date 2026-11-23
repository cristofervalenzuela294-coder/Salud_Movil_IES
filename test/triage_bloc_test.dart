import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/patient_draft.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/triage_level.dart';
import 'package:saludmovil_ies/features/triage/domain/entities/vital_signs.dart';
import 'package:saludmovil_ies/features/triage/domain/usecases/triage_calculator.dart';
import 'package:saludmovil_ies/features/triage/presentation/bloc/triage_bloc.dart';

void main() {
  const draft = PatientDraft(
      dni: '12345678', name: 'Prueba', age: 30, reason: 'Control médico');

  test('guarda los datos de admisión', () async {
    final bloc = TriageBloc(const TriageCalculator());
    bloc.add(const TriageDraftSaved(draft));
    final s = await bloc.stream.first;
    expect(s.draft, draft);
    expect(s.assessment, isNull);
    await bloc.close();
  });

  test('calcula la prioridad conservando la admisión', () async {
    final bloc = TriageBloc(const TriageCalculator());
    bloc.add(const TriageDraftSaved(draft));
    bloc.add(const TriageVitalsSubmitted(VitalSigns(
        systolic: 120, diastolic: 80, spo2: 80, heartRate: 75, pain: 0)));
    final s = await bloc.stream.firstWhere((s) => s.assessment != null);
    expect(s.draft, draft);
    expect(s.assessment!.level, TriageLevel.i); // SpO2 de 80 es crítica
    await bloc.close();
  });

  test('reiniciar limpia el flujo', () async {
    final bloc = TriageBloc(const TriageCalculator());
    bloc.add(const TriageDraftSaved(draft));
    await bloc.stream.first;
    bloc.add(const TriageReset());
    final s = await bloc.stream.first;
    expect(s.draft, isNull);
    expect(s.assessment, isNull);
    await bloc.close();
  });
}
