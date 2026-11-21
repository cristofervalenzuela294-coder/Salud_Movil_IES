import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/geo.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../data/sedes_catalog.dart';
import '../../domain/entities/sede.dart';
import '../cubit/location_cubit.dart';
import '../widgets/sedes_map.dart';

class SedeDetailPage extends StatelessWidget {
  const SedeDetailPage({super.key, this.sede});
  final Sede? sede;

  @override
  Widget build(BuildContext context) {
    final s = sede ?? sedesCatalog.first;
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, loc) {
        final user = loc.position;
        final distance = user == null
            ? 'Ubicación no disponible'
            : formatDistance(distanceKm(user, s.position));
        return ScreenLayout(
          title: s.name,
          subtitle: s.specialties.join(' · '),
          bottom: ButtonPair(
            left: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('VOLVER'),
            ),
            right: FilledButton(
              onPressed: () => context.go('/citas/agendar'),
              child: const Text('AGENDAR'),
            ),
          ),
          child: SpacedList(
            children: [
              SedesMap(sedes: [s], user: user, focus: s.position, height: 200),
              WhitePanel(
                child: Column(
                  children: [
                    InfoRow('Distancia', distance),
                    InfoRow('Especialidades', s.specialties.join(', ')),
                    const InfoRow('Horario', '[Por definir]'),
                    const InfoRow('Dirección', '[Por definir]'),
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
