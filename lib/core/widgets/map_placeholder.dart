import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Mapa ilustrativo. En el Hito 9 se reemplaza por un mapa real con GPS.
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.height = 240});
  final double height;

  Widget _pin(double left, double top, Color color) => Positioned(
        left: left,
        top: top,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFDCE8E6),
        child: Stack(
          children: [
            Positioned(
              left: -40,
              right: -40,
              top: height * 0.45,
              child: Transform.rotate(
                angle: -0.2,
                child: Container(height: 18, color: Colors.white),
              ),
            ),
            Positioned(
              top: -30,
              bottom: -30,
              left: 180,
              child: Transform.rotate(
                angle: 0.25,
                child: Container(width: 18, color: Colors.white),
              ),
            ),
            _pin(60, height * 0.25, AppColors.navy),
            _pin(220, height * 0.65, AppColors.navy),
            _pin(110, height * 0.7, AppColors.navy),
            _pin(160, height * 0.4, AppColors.levelV),
          ],
        ),
      ),
    );
  }
}
