import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../domain/entities/vital_signs.dart';
import '../bloc/triage_bloc.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key});

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  final _form = GlobalKey<FormState>();
  final _pressure = TextEditingController();
  final _spo2 = TextEditingController();
  final _heartRate = TextEditingController();
  double _pain = 0;

  @override
  void dispose() {
    _pressure.dispose();
    _spo2.dispose();
    _heartRate.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revise los valores marcados')),
      );
      return;
    }
    final parts = _pressure.text.split('/');
    context.read<TriageBloc>().add(TriageVitalsSubmitted(VitalSigns(
          systolic: int.parse(parts[0].trim()),
          diastolic: int.parse(parts[1].trim()),
          spo2: int.parse(_spo2.text.trim()),
          heartRate: int.parse(_heartRate.text.trim()),
          pain: _pain.round(),
        )));
    context.push('/pacientes/resultado');
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<TriageBloc>().state.draft;
    return ScreenLayout(
      title: 'Signos vitales',
      subtitle: draft?.label ?? 'Paciente sin datos de admisión',
      bottom: FilledButton(
        onPressed: _submit,
        child: const Text('CALCULAR PRIORIDAD'),
      ),
      child: Form(
        key: _form,
        child: SpacedList(
          children: [
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
              hint: '50 a 100',
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
              hint: '20 a 250',
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
