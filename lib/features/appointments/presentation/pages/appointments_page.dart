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

  void _options(BuildContext context, Appointment a) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar cita'),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/citas/agendar', extra: a);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Cancelar cita'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmCancel(context, a);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, Appointment a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar cita'),
        content: Text('¿Cancelar la cita de ${a.specialty} del ${a.date}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('NO')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('SÍ, CANCELAR')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final cubit = context.read<AppointmentsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    await cubit.delete(a.id!);
    messenger.showSnackBar(SnackBar(
      content: const Text('Cita cancelada'),
      action: SnackBarAction(label: 'DESHACER', onPressed: () => cubit.add(a)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, List<Appointment>>(
      builder: (context, items) {
        return ScreenLayout(
          title: 'Mis citas',
          subtitle: 'Toque una cita para editarla o cancelarla',
          bottom: FilledButton(
            onPressed: () => context.push('/citas/agendar'),
            child: const Text('AGENDAR CITA'),
          ),
          child: items.isEmpty
              ? const Center(
                  child: Text('No tiene citas programadas',
                      style: TextStyle(color: AppColors.navy, fontSize: 16)))
              : SpacedList(
                  children: [
                    for (final a in items)
                      ItemCard(
                        title: a.specialty,
                        subtitle: '${a.date} · ${a.time} · ${a.sede}',
                        chipLabel: a.confirmed ? 'Confirmada' : 'Pendiente',
                        chipColor:
                            a.confirmed ? AppColors.levelIV : AppColors.levelIII,
                        onTap: () => _options(context, a),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
