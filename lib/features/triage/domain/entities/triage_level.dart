import "dart:ui";

import "../../../../core/theme/app_colors.dart";

enum TriageLevel {
  i("I · Inmediato", AppColors.levelI),
  ii("II · Muy urgente", AppColors.levelII),
  iii("III · Urgente", AppColors.levelIII),
  iv("IV · Poco urgente", AppColors.levelIV),
  v("V · No urgente", AppColors.levelV);

  const TriageLevel(this.label, this.color);
  final String label;
  final Color color;
}
