import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/screen_layout.dart';

class SedeDetailPage extends StatelessWidget {
  const SedeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Sede Principal',
      subtitle: 'Medicina general · 1.2 km',
      bottom: ButtonPair(
        left: OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('VOLVER'),
        ),
        right: FilledButton(
          onPressed: () => context.go('/citas/agendar'),
          child: const Text('AGENDAR'),
        ),
      ),
      child: const SpacedList(
        children: [
          MapPlaceholder(height: 180),
          WhitePanel(
            child: Column(
              children: [
                InfoRow('Especialidades', 'Medicina, Pediatría'),
                InfoRow('Horario', '[Por definir]'),
                InfoRow('Dirección', '[Por definir]'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
