import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../domain/entities/patient.dart';
import '../bloc/patients_bloc.dart';
import '../bloc/triage_bloc.dart';

class TriageResultPage extends StatelessWidget {
  const TriageResultPage({super.key});

  void _save(BuildContext context, TriageState s) {
    final d = s.draft;
    final a = s.assessment;
    if (d == null || a == null) return;
    context.read<PatientsBloc>().add(PatientSaved(Patient(
          name: d.name,
          age: d.age,
          reason: d.reason,
          level: a.level,
          dni: d.dni,
          vitals: a.vitals,
        )));
    context.read<TriageBloc>().add(const TriageReset());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ficha guardada en este dispositivo')),
    );
    context.go('/pacientes');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TriageBloc, TriageState>(
      builder: (context, state) {
        final a = state.assessment;
        if (a == null) {
          return const ScreenLayout(
            title: 'Resultado de triage',
            subtitle: 'Sin evaluación',
            child: Center(
              child: Text('Primero registre los signos vitales',
                  style: TextStyle(color: AppColors.navy, fontSize: 16)),
            ),
          );
        }
        final level = a.level;
        final fg = level.color.computeLuminance() > 0.3 ? Colors.black : Colors.white;
        return ScreenLayout(
          title: 'Resultado de triage',
          subtitle: state.draft?.label ?? '',
          bottom: ButtonPair(
            left: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('EDITAR'),
            ),
            right: FilledButton(
              onPressed: () => _save(context, state),
              child: const Text('GUARDAR FICHA'),
            ),
          ),
          child: SpacedList(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: level.color,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NIVEL ${level.roman}',
                        style: TextStyle(fontSize: 18, color: fg)),
                    Text(level.title, style: TextStyle(fontSize: 40, color: fg)),
                    const SizedBox(height: 4),
                    Text(level.action, style: TextStyle(fontSize: 16, color: fg)),
                  ],
                ),
              ),
              WhitePanel(
                child: Column(
                  children: [
                    for (final f in a.findings)
                      InfoRow(f.name, '${f.value} · ${f.flag}'),
                  ],
                ),
              ),
              const Text(
                'La ficha se guarda en este dispositivo y se sincroniza cuando haya red.',
                style: TextStyle(color: AppColors.navy),
              ),
            ],
          ),
        );
      },
    );
  }
}
