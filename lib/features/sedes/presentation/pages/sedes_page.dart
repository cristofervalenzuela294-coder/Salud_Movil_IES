import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/geo.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../data/sedes_catalog.dart';
import '../cubit/location_cubit.dart';
import '../widgets/sedes_map.dart';

class SedesPage extends StatefulWidget {
  const SedesPage({super.key});

  @override
  State<SedesPage> createState() => _SedesPageState();
}

class _SedesPageState extends State<SedesPage> {
  String? _specialty; // null = todas

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().start();
  }

  String _subtitle(LocationState loc) => switch (loc.status) {
        LocationStatus.ready => 'Ubicación en tiempo real',
        LocationStatus.loading => 'Obteniendo ubicación…',
        LocationStatus.error => 'Sin ubicación',
        LocationStatus.initial => 'Sedes disponibles',
      };

  @override
  Widget build(BuildContext context) {
    final specialties = {for (final s in sedesCatalog) ...s.specialties}.toList()..sort();
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, loc) {
        final user = loc.position;
        final sedes = sedesCatalog
            .where((s) => _specialty == null || s.specialties.contains(_specialty))
            .toList();
        if (user != null) {
          sedes.sort((a, b) => distanceKm(user, a.position)
              .compareTo(distanceKm(user, b.position)));
        }
        return ScreenLayout(
          title: 'Sedes cercanas',
          subtitle: _subtitle(loc),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  for (final label in [null, ...specialties])
                    ChoiceChip(
                      label: Text(label ?? 'Todas'),
                      selected: _specialty == label,
                      showCheckmark: false,
                      selectedColor: AppColors.navy,
                      labelStyle: TextStyle(
                          color: _specialty == label ? Colors.white : AppColors.navy),
                      onSelected: (_) => setState(() => _specialty = label),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (loc.status == LocationStatus.error) ...[
                Row(
                  children: [
                    Expanded(child: OfflineBanner(loc.message ?? 'Sin ubicación')),
                    IconButton(
                      tooltip: 'Reintentar',
                      icon: const Icon(Icons.refresh, color: AppColors.navy),
                      onPressed: () =>
                          context.read<LocationCubit>().start(force: true),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              SedesMap(
                sedes: sedes,
                user: user,
                height: 220,
                onSedeTap: (s) => context.push('/mapa/sede', extra: s),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SpacedList(
                  children: [
                    for (final s in sedes)
                      ItemCard(
                        title: s.name,
                        subtitle: s.specialties.join(' · '),
                        chipLabel:
                            user == null ? '—' : formatDistance(distanceKm(user, s.position)),
                        chipColor: AppColors.navy,
                        onTap: () => context.push('/mapa/sede', extra: s),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
