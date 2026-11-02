import 'dart:ui';

import '../../../../core/theme/app_colors.dart';

enum TriageLevel {
  i('I', 'Inmediato', AppColors.levelI, 'Atención inmediata'),
  ii('II', 'Muy urgente', AppColors.levelII, 'Derivar a consulta prioritaria'),
  iii('III', 'Urgente', AppColors.levelIII, 'Atender en turno urgente'),
  iv('IV', 'Poco urgente', AppColors.levelIV, 'Atender en consulta ordinaria'),
  v('V', 'No urgente', AppColors.levelV, 'Puede esperar o ser derivado');

  const TriageLevel(this.roman, this.title, this.color, this.action);
  final String roman;
  final String title;
  final Color color;
  final String action;

  String get label => '$roman · $title';
}
