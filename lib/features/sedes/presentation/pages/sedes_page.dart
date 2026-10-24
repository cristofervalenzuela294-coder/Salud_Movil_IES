import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/screen_layout.dart';

class SedesPage extends StatelessWidget {
  const SedesPage({super.key});

  Widget _chip(String label, bool selected) => ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.navy,
        labelStyle: TextStyle(color: selected ? Colors.white : AppColors.navy),
        onSelected: (_) {},
      );

  @override
  Widget build(BuildContext context) {
    void open() => context.push('/mapa/sede');
    return ScreenLayout(
      title: 'Sedes cercanas',
      subtitle: 'Medicina general · Pediatría',
      child: SpacedList(
        children: [
          Wrap(spacing: 8, children: [
            _chip('Medicina general', true),
            _chip('Pediatría', false),
          ]),
          const MapPlaceholder(),
          ItemCard(
              title: 'Sede Principal',
              subtitle: 'Medicina general',
              chipLabel: '1.2 km',
              chipColor: AppColors.navy,
              onTap: open),
          ItemCard(
              title: 'Ambulatorio Norte',
              subtitle: 'Pediatría',
              chipLabel: '2.8 km',
              chipColor: AppColors.navy,
              onTap: open),
          ItemCard(
              title: 'Campaña itinerante',
              subtitle: 'Obstetricia',
              chipLabel: '4.1 km',
              chipColor: AppColors.navy,
              onTap: open),
        ],
      ),
    );
  }
}
