import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';

class TriageResultPage extends StatelessWidget {
  const TriageResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Resultado de triage',
      subtitle: 'Rosa M. · 54 años',
      bottom: ButtonPair(
        left: OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('EDITAR'),
        ),
        right: FilledButton(
          onPressed: () => context.go('/pacientes'),
          child: const Text('GUARDAR FICHA'),
        ),
      ),
      child: SpacedList(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.levelII,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NIVEL II', style: TextStyle(fontSize: 18)),
                Text('Muy urgente', style: TextStyle(fontSize: 40)),
                SizedBox(height: 4),
                Text('Derivar a consulta prioritaria',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const WhitePanel(
            child: Column(
              children: [
                InfoRow('Presión', '150/95 · Elevada'),
                InfoRow('SpO₂', '91 % · Baja'),
                InfoRow('Frec. cardíaca', '112 lpm · Alta'),
                InfoRow('Dolor', '6 / 10 · Moderado'),
              ],
            ),
          ),
          const Text(
            'La ficha se guarda en este dispositivo y se sincroniza cuando haya red.',
            style: TextStyle(color: AppColors.navy),
          ),
        ],
      ),
    );
  }
}
