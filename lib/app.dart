import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/appointments/presentation/cubit/appointments_cubit.dart';
import 'features/triage/presentation/bloc/patients_bloc.dart';
import 'features/triage/presentation/bloc/triage_bloc.dart';

class SaludMovilApp extends StatelessWidget {
  const SaludMovilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PatientsBloc>()),
        BlocProvider(create: (_) => getIt<TriageBloc>()),
        BlocProvider(create: (_) => getIt<AppointmentsCubit>()),
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
