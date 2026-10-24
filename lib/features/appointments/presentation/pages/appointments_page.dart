import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Mis citas',
      subtitle: 'Paciente',
      bottom: FilledButton(
        onPressed: () => context.push('/citas/agendar'),
        child: const Text('AGENDAR CITA'),
      ),
      child: const SpacedList(
        children: [
          ItemCard(
            title: 'Medicina general',
            subtitle: 'Jue 22 oct · 10:30 · Sede Principal',
            chipLabel: 'Confirmada',
            chipColor: AppColors.levelIV,
          ),
          ItemCard(
            title: 'Pediatría',
            subtitle: 'Lun 26 oct · 09:00 · Ambulatorio Norte',
            chipLabel: 'Pendiente',
            chipColor: AppColors.levelIII,
          ),
        ],
      ),
    );
  }
}
