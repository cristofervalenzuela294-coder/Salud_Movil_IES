import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Sincronización',
      subtitle: 'Sistema',
      bottom: FilledButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La sincronización real llega en el Hito 8')),
        ),
        child: const Text('SINCRONIZAR AHORA'),
      ),
      child: const SpacedList(
        children: [
          OfflineBanner('Sin conexión · 3 fichas pendientes'),
          ItemCard(
              title: 'Luis Q.',
              subtitle: 'Ficha de triage',
              chipLabel: 'Pendiente',
              chipColor: AppColors.levelIII),
          ItemCard(
              title: 'Rosa M.',
              subtitle: 'Ficha de triage',
              chipLabel: 'Pendiente',
              chipColor: AppColors.levelIII),
          ItemCard(
              title: 'Carlos P.',
              subtitle: 'Error de servidor, reintentar',
              chipLabel: 'Error',
              chipColor: AppColors.levelI),
          ItemCard(
              title: 'Ana T.',
              subtitle: 'Enviada hace 5 min',
              chipLabel: 'Enviada',
              chipColor: AppColors.levelIV),
        ],
      ),
    );
  }
}
