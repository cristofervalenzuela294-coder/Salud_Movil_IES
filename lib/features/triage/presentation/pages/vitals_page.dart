import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key});

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  double _pain = 6;

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Signos vitales',
      subtitle: 'Rosa M. · 54 años',
      bottom: FilledButton(
        onPressed: () => context.push('/pacientes/resultado'),
        child: const Text('CALCULAR PRIORIDAD'),
      ),
      child: SpacedList(
        children: [
          const LabeledField(
              label: 'Presión arterial (mmHg)',
              initialValue: '150 / 95',
              keyboardType: TextInputType.text),
          const LabeledField(
              label: 'Saturación SpO₂ (%)',
              initialValue: '91',
              keyboardType: TextInputType.number),
          const LabeledField(
              label: 'Frecuencia cardíaca (lpm)',
              initialValue: '112',
              keyboardType: TextInputType.number),
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
          const ItemCard(
            title: 'Prioridad estimada',
            subtitle: 'Se calcula al guardar',
            chipLabel: 'II · Muy urgente',
            chipColor: AppColors.levelII,
          ),
        ],
      ),
    );
  }
}
