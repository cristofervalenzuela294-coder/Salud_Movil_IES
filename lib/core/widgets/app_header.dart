import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Tarjeta menta de encabezado. Muestra una flecha de retorno si hay a dónde volver.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          if (context.canPop())
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.navy),
              onPressed: () => context.pop(),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 26, color: AppColors.navy)),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
