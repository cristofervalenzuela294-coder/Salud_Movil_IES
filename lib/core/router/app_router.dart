import "package:go_router/go_router.dart";

import "../../features/auth/presentation/pages/login_page.dart";
import "../../features/triage/presentation/pages/waiting_list_page.dart";

final appRouter = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (_, __) => const LoginPage()),
    GoRoute(path: "/pacientes", builder: (_, __) => const WaitingListPage()),
  ],
);
