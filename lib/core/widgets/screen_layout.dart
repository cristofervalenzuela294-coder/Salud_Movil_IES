import 'package:flutter/material.dart';

import 'app_header.dart';

/// Estructura común: encabezado, contenido desplazable y botón(es) inferior(es).
class ScreenLayout extends StatelessWidget {
  const ScreenLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.bottom,
  });
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 16),
        Expanded(child: child),
        if (bottom != null) ...[const SizedBox(height: 16), bottom!],
      ],
    );
  }
}

/// Lista vertical con separación uniforme entre elementos.
class SpacedList extends StatelessWidget {
  const SpacedList({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: children.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => children[i],
    );
  }
}

/// Dos botones de igual ancho, uno al lado del otro.
class ButtonPair extends StatelessWidget {
  const ButtonPair({super.key, required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}
