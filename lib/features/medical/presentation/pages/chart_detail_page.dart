import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';

class ChartDetailPage extends StatelessWidget {
  const ChartDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Ficha de Rosa M.',
      subtitle: '54 años · Dificultad respiratoria',
      bottom: ButtonPair(
        left: OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('VOLVER'),
        ),
        right: FilledButton(
          onPressed: () => context.go('/avisos'),
          child: const Text('LLAMAR'),
        ),
      ),
      child: SpacedList(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.levelII,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text('NIVEL II · Muy urgente',
                style: TextStyle(fontSize: 22)),
          ),
          const WhitePanel(
            child: Column(
              children: [
                InfoRow('Presión', '150/95 mmHg'),
                InfoRow('SpO₂', '91 %'),
                InfoRow('Frec. cardíaca', '112 lpm'),
                InfoRow('Dolor', '6 / 10'),
              ],
            ),
          ),
          const WhitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Observaciones de enfermería',
                    style: TextStyle(fontSize: 16, color: AppColors.navy)),
                SizedBox(height: 6),
                Text('Refiere falta de aire desde la mañana. '
                    'Sin antecedentes registrados.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
