import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../domain/entities/app_notification.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().refreshToken();
  }

  (String, Color) _style(String type) => switch (type) {
        'call' => ('Llamado', AppColors.levelI),
        'reminder' => ('Recordatorio', AppColors.levelV),
        'confirmation' => ('Confirmación', AppColors.levelIV),
        _ => ('Aviso', AppColors.navy),
      };

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  Future<void> _copyToken(BuildContext context, String token) async {
    await Clipboard.setData(ClipboardData(text: token));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Token FCM copiado')));
  }

  Widget _card(AppNotification n) {
    final (label, color) = _style(n.type);
    return ItemCard(
      title: n.title,
      subtitle: '${n.body} · ${_hhmm(n.receivedAt)}',
      chipLabel: label,
      chipColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, s) {
        final token = s.token;
        return ScreenLayout(
          title: 'Notificaciones',
          subtitle: s.available ? 'Push activas' : 'Push no disponibles',
          bottom: token == null
              ? null
              : FilledButton(
                  onPressed: () => _copyToken(context, token),
                  child: const Text('COPIAR TOKEN FCM'),
                ),
          child: SpacedList(
            children: [
              if (!s.available)
                const OfflineBanner(
                    'Las notificaciones push requieren un dispositivo Android con Firebase configurado.'),
              if (s.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Aún no hay avisos',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.navy, fontSize: 16)),
                ),
              for (final n in s.items) _card(n),
            ],
          ),
        );
      },
    );
  }
}
