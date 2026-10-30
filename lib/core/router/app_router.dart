import 'package:go_router/go_router.dart';

import '../../features/appointments/presentation/pages/appointments_page.dart';
import '../../features/appointments/presentation/pages/book_appointment_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/medical/presentation/pages/chart_detail_page.dart';
import '../../features/medical/presentation/pages/charts_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/sedes/presentation/pages/sede_detail_page.dart';
import '../../features/sedes/presentation/pages/sedes_page.dart';
import '../../features/sync/presentation/pages/sync_page.dart';
import '../../features/triage/presentation/pages/new_patient_page.dart';
import '../../features/triage/presentation/pages/triage_result_page.dart';
import '../../features/triage/presentation/pages/vitals_page.dart';
import '../../features/triage/presentation/pages/waiting_list_page.dart';
import '../widgets/main_shell.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginPage()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/pacientes',
          builder: (_, __) => const WaitingListPage(),
          routes: [
            GoRoute(path: 'nuevo', builder: (_, __) => const NewPatientPage()),
            GoRoute(
              path: 'signos',
              builder: (_, s) => VitalsPage(patientLabel: s.extra as String?),
            ),
            GoRoute(path: 'resultado', builder: (_, __) => const TriageResultPage()),
          ],
        ),
        GoRoute(
          path: '/fichas',
          builder: (_, __) => const ChartsPage(),
          routes: [
            GoRoute(path: 'detalle', builder: (_, __) => const ChartDetailPage()),
          ],
        ),
        GoRoute(
          path: '/citas',
          builder: (_, __) => const AppointmentsPage(),
          routes: [
            GoRoute(path: 'agendar', builder: (_, __) => const BookAppointmentPage()),
          ],
        ),
        GoRoute(
          path: '/mapa',
          builder: (_, __) => const SedesPage(),
          routes: [
            GoRoute(path: 'sede', builder: (_, __) => const SedeDetailPage()),
          ],
        ),
        GoRoute(path: '/avisos', builder: (_, __) => const NotificationsPage()),
        GoRoute(path: '/sync', builder: (_, __) => const SyncPage()),
      ],
    ),
  ],
);
