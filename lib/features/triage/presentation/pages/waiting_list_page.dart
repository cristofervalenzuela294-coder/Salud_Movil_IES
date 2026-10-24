import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../sample_data.dart';

class WaitingListPage extends StatelessWidget {
  const WaitingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Pacientes en espera',
      subtitle: 'Enfermería · Triage',
      bottom: FilledButton(
        onPressed: () => context.push('/pacientes/signos'),
        child: const Text('+ NUEVO PACIENTE'),
      ),
      child: SpacedList(
        children: [
          const OfflineBanner('Sin conexión · 3 fichas pendientes de sincronizar'),
          for (final p in samplePatients)
            ItemCard(
              title: p.name,
              subtitle: '${p.age} años · ${p.reason}',
              chipLabel: p.level.label,
              chipColor: p.level.color,
              onTap: () => context.go('/fichas'),
            ),
        ],
      ),
    );
  }
}
