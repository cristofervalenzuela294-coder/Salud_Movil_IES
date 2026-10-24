import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tarjeta blanca con título, subtítulo y una etiqueta de color a la derecha.
class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.chipLabel,
    required this.chipColor,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final String chipLabel;
  final Color chipColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = chipColor.computeLuminance() > 0.3 ? Colors.black : Colors.white;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 20, color: AppColors.navy)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(chipLabel,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
