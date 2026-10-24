import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../../triage/presentation/sample_data.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Fichas por prioridad',
      subtitle: 'Médico',
      bottom: FilledButton(
        onPressed: () => context.go('/avisos'),
        child: const Text('LLAMAR SIGUIENTE PACIENTE'),
      ),
      child: SpacedList(
        children: [
          const LabeledField(
            label: 'Buscar paciente',
            hint: 'Buscar por DNI o nombre',
            suffixIcon: Icon(Icons.search),
          ),
          for (final p in samplePatients.take(4))
            ItemCard(
              title: p.name,
              subtitle: p.reason,
              chipLabel: p.level.name.toUpperCase(),
              chipColor: p.level.color,
              onTap: () => context.push('/fichas/detalle'),
            ),
        ],
      ),
    );
  }
}
