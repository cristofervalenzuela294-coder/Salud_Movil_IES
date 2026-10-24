import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'gradient_background.dart';

/// Marco común de la app: fondo degradado y barra de navegación inferior.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  static const _paths = ['/pacientes', '/citas', '/mapa', '/avisos', '/sync'];

  int _indexFor(String location) {
    if (location.startsWith('/citas')) return 1;
    if (location.startsWith('/mapa')) return 2;
    if (location.startsWith('/avisos')) return 3;
    if (location.startsWith('/sync')) return 4;
    return 0; // /pacientes y /fichas
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexFor(location),
        onDestinationSelected: (i) => context.go(_paths[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Citas'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          NavigationDestination(
              icon: Icon(Icons.notifications_outlined), label: 'Avisos'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Sync'),
        ],
      ),
    );
  }
}
