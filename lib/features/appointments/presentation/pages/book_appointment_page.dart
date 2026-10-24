import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    const arrow = Icon(Icons.arrow_drop_down);
    return ScreenLayout(
      title: 'Agendar cita',
      subtitle: 'Paciente',
      bottom: ButtonPair(
        left: OutlinedButton(
          onPressed: () => context.go('/citas'),
          child: const Text('CANCELAR'),
        ),
        right: FilledButton(
          onPressed: () => context.go('/citas'),
          child: const Text('CONFIRMAR'),
        ),
      ),
      child: const SpacedList(
        children: [
          LabeledField(
              label: 'Especialidad',
              initialValue: 'Medicina general',
              readOnly: true,
              suffixIcon: arrow),
          LabeledField(
              label: 'Sede',
              initialValue: 'Sede Principal',
              readOnly: true,
              suffixIcon: arrow),
          LabeledField(
              label: 'Fecha',
              initialValue: 'Jue 22 oct',
              readOnly: true,
              suffixIcon: Icon(Icons.calendar_today_outlined)),
          LabeledField(
              label: 'Hora',
              initialValue: '10:30',
              readOnly: true,
              suffixIcon: Icon(Icons.access_time)),
        ],
      ),
    );
  }
}
