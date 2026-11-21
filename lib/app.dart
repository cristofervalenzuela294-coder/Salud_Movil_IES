import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/push/push_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/appointments/presentation/cubit/appointments_cubit.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/sedes/presentation/cubit/location_cubit.dart';
import 'features/triage/presentation/bloc/patients_bloc.dart';
import 'features/triage/presentation/bloc/triage_bloc.dart';

class SaludMovilApp extends StatefulWidget {
  const SaludMovilApp({super.key});

  @override
  State<SaludMovilApp> createState() => _SaludMovilAppState();
}

class _SaludMovilAppState extends State<SaludMovilApp> {
  final _notifications = getIt<NotificationsCubit>();
  StreamSubscription<PushMessage>? _openedSub;

  @override
  void initState() {
    super.initState();
    // Tocar una notificación con la app en segundo plano abre la pestaña Avisos.
    _openedSub = getIt<PushService>().onOpened.listen((_) => appRouter.go('/avisos'));
    // Lo mismo si la app estaba cerrada y se abrió desde la notificación.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifications.openInitial()) appRouter.go('/avisos');
    });
  }

  @override
  void dispose() {
    _openedSub?.cancel();
    _notifications.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PatientsBloc>()),
        BlocProvider(create: (_) => getIt<TriageBloc>()),
        BlocProvider(create: (_) => getIt<AppointmentsCubit>()),
        BlocProvider(create: (_) => getIt<LocationCubit>()),
        BlocProvider.value(value: _notifications),
      ],
      child: MaterialApp.router(
        title: 'SaludMovil IES',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
