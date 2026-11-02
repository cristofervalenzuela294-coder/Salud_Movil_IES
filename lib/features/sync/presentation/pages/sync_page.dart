import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../../triage/presentation/bloc/patients_bloc.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsBloc, PatientsState>(
      builder: (context, state) {
        final canSync = state.pending > 0 && !state.syncing;
        return ScreenLayout(
          title: 'Sincronización',
          subtitle: 'Sistema',
          bottom: FilledButton(
            onPressed: canSync
                ? () => context.read<PatientsBloc>().add(const SyncRequested())
                : null,
            child: Text(state.syncing ? 'SINCRONIZANDO...' : 'SINCRONIZAR AHORA'),
          ),
          child: SpacedList(
            children: [
              OfflineBanner(state.pending == 0
                  ? 'Todo sincronizado'
                  : 'Sin conexión · ${state.pending} fichas pendientes'),
              for (final p in state.patients)
                ItemCard(
                  title: p.name,
                  subtitle: 'Ficha de triage',
                  chipLabel: p.synced ? 'Enviada' : 'Pendiente',
                  chipColor: p.synced ? AppColors.levelIV : AppColors.levelIII,
                ),
            ],
          ),
        );
      },
    );
  }
}
