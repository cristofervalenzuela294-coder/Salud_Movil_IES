import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../../triage/presentation/bloc/patients_bloc.dart';

class ChartDetailPage extends StatelessWidget {
  const ChartDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsBloc, PatientsState>(
      builder: (context, state) {
        final p = state.selected ??
            (state.patients.isNotEmpty ? state.patients.first : null);
        if (p == null) {
          return const ScreenLayout(
            title: 'Ficha',
            subtitle: 'Sin selección',
            child: Center(child: Text('Seleccione un paciente')),
          );
        }
        final v = p.vitals;
        final fg = p.level.color.computeLuminance() > 0.3 ? Colors.black : Colors.white;
        return ScreenLayout(
          title: 'Ficha de ${p.name}',
          subtitle: '${p.age} años · ${p.reason}',
          bottom: ButtonPair(
            left: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('VOLVER'),
            ),
            right: FilledButton(
              onPressed: () => context.go('/avisos'),
              child: const Text('LLAMAR'),
            ),
          ),
          child: SpacedList(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: p.level.color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text('NIVEL ${p.level.label}',
                    style: TextStyle(fontSize: 22, color: fg)),
              ),
              if (v != null)
                WhitePanel(
                  child: Column(
                    children: [
                      InfoRow('Presión', '${v.pressureText} mmHg'),
                      InfoRow('SpO₂', '${v.spo2} %'),
                      InfoRow('Frec. cardíaca', '${v.heartRate} lpm'),
                      InfoRow('Dolor', '${v.pain} / 10'),
                    ],
                  ),
                ),
              WhitePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Motivo de consulta',
                        style: TextStyle(fontSize: 16, color: AppColors.navy)),
                    const SizedBox(height: 6),
                    Text(p.reason),
                    const SizedBox(height: 10),
                    Text(p.synced ? 'Sincronizada' : 'Pendiente de sincronizar',
                        style: const TextStyle(color: AppColors.navy)),
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
