import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../../triage/presentation/bloc/patients_bloc.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientsBloc, PatientsState>(
      listenWhen: (prev, curr) =>
          prev.syncMessage != curr.syncMessage && curr.syncMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.syncMessage!)));
      },
      builder: (context, state) {
        return ScreenLayout(
          title: 'Sincronización',
          subtitle: 'Servidor: ${ApiConfig.baseUrl}',
          bottom: FilledButton(
            onPressed: state.syncing
                ? null
                : () => context.read<PatientsBloc>().add(const SyncRequested()),
            child: Text(state.syncing ? 'SINCRONIZANDO...' : 'SINCRONIZAR AHORA'),
          ),
          child: SpacedList(
            children: [
              OfflineBanner(state.pending == 0
                  ? 'Todo sincronizado'
                  : '${state.pending} fichas pendientes de enviar'),
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
