import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../domain/entities/vital_signs.dart';
import '../../domain/usecases/triage_calculator.dart';
import '../bloc/patients_bloc.dart';

/// Edita los datos y signos vitales de una ficha y recalcula su prioridad.
class EditPatientPage extends StatefulWidget {
  const EditPatientPage({super.key});

  @override
  State<EditPatientPage> createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  final _form = GlobalKey<FormState>();
  final _dni = TextEditingController();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _reason = TextEditingController();
  final _pressure = TextEditingController();
  final _spo2 = TextEditingController();
  final _heartRate = TextEditingController();
  double _pain = 0;

  @override
  void initState() {
    super.initState();
    final p = context.read<PatientsBloc>().state.selected;
    if (p == null) return;
    _dni.text = p.dni;
    _name.text = p.name;
    _age.text = '${p.age}';
    _reason.text = p.reason;
    final v = p.vitals;
    if (v != null) {
      _pressure.text = v.pressureText;
      _spo2.text = '${v.spo2}';
      _heartRate.text = '${v.heartRate}';
      _pain = v.pain.toDouble();
    }
  }

  @override
  void dispose() {
    for (final c in [_dni, _name, _age, _reason, _pressure, _spo2, _heartRate]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final p = context.read<PatientsBloc>().state.selected;
    if (p == null) return;
    if (!_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revise los campos marcados')),
      );
      return;
    }
    final parts = _pressure.text.split('/');
    final vitals = VitalSigns(
      systolic: int.parse(parts[0].trim()),
      diastolic: int.parse(parts[1].trim()),
      spo2: int.parse(_spo2.text.trim()),
      heartRate: int.parse(_heartRate.text.trim()),
      pain: _pain.round(),
    );
    final level = getIt<TriageCalculator>().evaluate(vitals).level;
    final updated = p.copyWith(
      dni: _dni.text.trim(),
      name: _name.text.trim(),
      age: int.parse(_age.text.trim()),
      reason: _reason.text.trim(),
      vitals: vitals,
      level: level,
      synced: false, // hay cambios pendientes de enviar
    );
    context.read<PatientsBloc>().add(PatientUpdated(updated));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ficha actualizada · Nivel ${level.label}')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Editar ficha',
      subtitle: 'Se recalcula la prioridad al guardar',
      bottom: ButtonPair(
        left: OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('CANCELAR'),
        ),
        right: FilledButton(onPressed: _save, child: const Text('GUARDAR')),
      ),
      child: Form(
        key: _form,
        child: SpacedList(
          children: [
            LabeledField(
              label: 'DNI',
              controller: _dni,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              validator: Validators.dni,
              textInputAction: TextInputAction.next,
            ),
            LabeledField(
              label: 'Nombre completo',
              controller: _name,
              validator: Validators.fullName,
              textInputAction: TextInputAction.next,
            ),
            LabeledField(
              label: 'Edad (años)',
              controller: _age,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              validator: (v) => Validators.intInRange(v,
                  field: 'La edad', min: 0, max: 120, unit: ' años'),
              textInputAction: TextInputAction.next,
            ),
            LabeledField(
              label: 'Motivo de consulta',
              controller: _reason,
              maxLines: 2,
              validator: (v) => Validators.minLength(v, 5, 'El motivo'),
            ),
            LabeledField(
              label: 'Presión arterial (mmHg)',
              controller: _pressure,
              hint: '120/80',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/ ]')),
                LengthLimitingTextInputFormatter(9),
              ],
              validator: Validators.bloodPressure,
              textInputAction: TextInputAction.next,
            ),
            LabeledField(
              label: 'Saturación SpO₂ (%)',
              controller: _spo2,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              validator: (v) => Validators.intInRange(v,
                  field: 'La saturación', min: 50, max: 100, unit: ' %'),
              textInputAction: TextInputAction.next,
            ),
            LabeledField(
              label: 'Frecuencia cardíaca (lpm)',
              controller: _heartRate,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              validator: (v) => Validators.intInRange(v,
                  field: 'La frecuencia', min: 20, max: 250, unit: ' lpm'),
              textInputAction: TextInputAction.done,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Escala de dolor: ${_pain.round()} / 10',
                    style: const TextStyle(fontSize: 18, color: AppColors.navy)),
                Slider(
                  value: _pain,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _pain.round().toString(),
                  onChanged: (v) => setState(() => _pain = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
