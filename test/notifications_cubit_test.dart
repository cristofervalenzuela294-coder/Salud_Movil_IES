import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:saludmovil_ies/core/push/push_service.dart';
import 'package:saludmovil_ies/features/notifications/presentation/cubit/notifications_cubit.dart';

class _FakePush implements PushService {
  final foreground = StreamController<PushMessage>.broadcast();
  final opened = StreamController<PushMessage>.broadcast();
  PushMessage? initial;

  @override
  bool get available => true;
  @override
  String? get token => 'token-de-prueba';
  @override
  Future<void> init() async {}
  @override
  Stream<PushMessage> get onForeground => foreground.stream;
  @override
  Stream<PushMessage> get onOpened => opened.stream;
  @override
  PushMessage? takeInitialMessage() {
    final m = initial;
    initial = null;
    return m;
  }
}

void main() {
  const call = PushMessage(
    id: 'm1',
    title: 'Pase al consultorio 3',
    body: 'Rosa M., diríjase ahora',
    data: {'type': 'call'},
  );

  test('expone el token y si FCM está disponible', () {
    final cubit = NotificationsCubit(_FakePush());
    expect(cubit.state.token, 'token-de-prueba');
    expect(cubit.state.available, isTrue);
    cubit.close();
  });

  test('un mensaje en primer plano se agrega y muestra banner', () async {
    final push = _FakePush();
    final cubit = NotificationsCubit(push);
    push.foreground.add(call);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.items.length, 1);
    expect(cubit.state.items.first.type, 'call');
    expect(cubit.state.banner?.title, 'Pase al consultorio 3');
    await cubit.close();
  });

  test('un mensaje tocado desde la bandeja se agrega sin banner', () async {
    final push = _FakePush();
    final cubit = NotificationsCubit(push);
    push.opened.add(call);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.items.length, 1);
    expect(cubit.state.banner, isNull);
    await cubit.close();
  });

  test('no duplica un mensaje con el mismo id', () async {
    final push = _FakePush();
    final cubit = NotificationsCubit(push);
    push.foreground.add(call);
    push.opened.add(call);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.items.length, 1);
    await cubit.close();
  });

  test('el mensaje que abrió la app se registra una sola vez', () async {
    final push = _FakePush()..initial = call;
    final cubit = NotificationsCubit(push);

    expect(cubit.openInitial(), isTrue);
    expect(cubit.state.items.length, 1);
    expect(cubit.openInitial(), isFalse);
    await cubit.close();
  });
}
