import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../bloc/patients_bloc.dart';

class WaitingListPage extends StatelessWidget {
  const WaitingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsBloc, PatientsState>(
      builder: (context, state) {
        return ScreenLayout(
          title: 'Pacientes en espera',
          subtitle: 'Enfermería · Triage',
          bottom: FilledButton(
            onPressed: () => context.push('/pacientes/nuevo'),
            child: const Text('+ NUEVO PACIENTE'),
          ),
          child: state.loading
              ? const Center(child: CircularProgressIndicator())
              : SpacedList(
                  children: [
                    OfflineBanner(state.pending == 0
                        ? 'Todo sincronizado'
                        : 'Sin conexión · ${state.pending} fichas pendientes de sincronizar'),
                    for (final p in state.patients)
                      ItemCard(
                        title: p.name,
                        subtitle: '${p.age} años · ${p.reason}',
                        chipLabel: p.level.label,
                        chipColor: p.level.color,
                        onTap: () {
                          context.read<PatientsBloc>().add(PatientSelected(p));
                          context.push('/fichas/detalle');
                        },
                      ),
                  ],
                ),
        );
      },
    );
  }
}
