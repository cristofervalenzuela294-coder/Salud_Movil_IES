import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/push/push_service.dart';
import '../../domain/entities/app_notification.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.items = const [],
    this.token,
    this.available = false,
    this.banner,
  });
  final List<AppNotification> items;
  final String? token;
  final bool available;

  /// Último aviso recibido con la app abierta (para mostrarlo como banner).
  final AppNotification? banner;

  NotificationsState copyWith({
    List<AppNotification>? items,
    String? token,
    bool? available,
    AppNotification? banner,
  }) =>
      NotificationsState(
        items: items ?? this.items,
        token: token ?? this.token,
        available: available ?? this.available,
        banner: banner ?? this.banner,
      );

  @override
  List<Object?> get props => [items, token, available, banner];
}

/// Recibe los push (FCM) y mantiene la lista de avisos.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._push)
      : super(NotificationsState(token: _push.token, available: _push.available)) {
    _subs.add(_push.onForeground.listen((m) => _add(m, showBanner: true)));
    _subs.add(_push.onOpened.listen((m) => _add(m, showBanner: false)));
  }

  final PushService _push;
  final List<StreamSubscription<PushMessage>> _subs = [];

  void refreshToken() =>
      emit(state.copyWith(token: _push.token, available: _push.available));

  /// Si la app se abrió tocando una notificación, la registra. Devuelve true si había una.
  bool openInitial() {
    final m = _push.takeInitialMessage();
    if (m == null) return false;
    _add(m, showBanner: false);
    return true;
  }

  void _add(PushMessage m, {required bool showBanner}) {
    if (m.id != null && state.items.any((n) => n.id == m.id)) return;
    final n = AppNotification(
      id: m.id,
      title: m.title,
      body: m.body,
      type: m.data['type'] ?? 'info',
      receivedAt: DateTime.now(),
    );
    emit(state.copyWith(
      items: [n, ...state.items],
      banner: showBanner ? n : null,
    ));
  }

  @override
  Future<void> close() async {
    for (final s in _subs) {
      await s.cancel();
    }
    return super.close();
  }
}
