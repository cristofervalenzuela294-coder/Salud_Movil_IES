import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenLayout(
      title: 'Notificaciones',
      subtitle: 'Avisos',
      child: SpacedList(
        children: [
          ItemCard(
            title: 'Pase al consultorio 3',
            subtitle: 'Rosa M., diríjase ahora',
            chipLabel: 'Ahora',
            chipColor: AppColors.levelI,
          ),
          ItemCard(
            title: 'Recordatorio de cita',
            subtitle: 'Mañana 10:30 · Medicina general',
            chipLabel: '2 h',
            chipColor: AppColors.levelV,
          ),
          ItemCard(
            title: 'Cita confirmada',
            subtitle: 'Lun 26 oct · Pediatría',
            chipLabel: 'Ayer',
            chipColor: AppColors.levelIV,
          ),
        ],
      ),
    );
  }
}
