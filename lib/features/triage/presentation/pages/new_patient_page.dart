import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';

class NewPatientPage extends StatefulWidget {
  const NewPatientPage({super.key});

  @override
  State<NewPatientPage> createState() => _NewPatientPageState();
}

class _NewPatientPageState extends State<NewPatientPage> {
  final _form = GlobalKey<FormState>();
  final _dni = TextEditingController();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _dni.dispose();
    _name.dispose();
    _age.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revise los campos marcados')),
      );
      return;
    }
    context.push('/pacientes/signos',
        extra: '${_name.text.trim()} · ${_age.text.trim()} años');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Nuevo paciente',
      subtitle: 'Datos de admisión',
      bottom: FilledButton(onPressed: _submit, child: const Text('CONTINUAR')),
      child: Form(
        key: _form,
        child: SpacedList(
          children: [
            LabeledField(
              label: 'DNI',
              controller: _dni,
              hint: '8 dígitos',
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
          ],
        ),
      ),
    );
  }
}
