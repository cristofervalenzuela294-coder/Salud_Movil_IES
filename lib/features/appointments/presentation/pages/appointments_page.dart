import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../domain/entities/appointment.dart';
import '../cubit/appointments_cubit.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, List<Appointment>>(
      builder: (context, items) {
        return ScreenLayout(
          title: 'Mis citas',
          subtitle: 'Paciente',
          bottom: FilledButton(
            onPressed: () => context.push('/citas/agendar'),
            child: const Text('AGENDAR CITA'),
          ),
          child: SpacedList(
            children: [
              for (final a in items)
                ItemCard(
                  title: a.specialty,
                  subtitle: '${a.date} · ${a.time} · ${a.sede}',
                  chipLabel: a.confirmed ? 'Confirmada' : 'Pendiente',
                  chipColor: a.confirmed ? AppColors.levelIV : AppColors.levelIII,
                ),
            ],
          ),
        );
      },
    );
  }
}
