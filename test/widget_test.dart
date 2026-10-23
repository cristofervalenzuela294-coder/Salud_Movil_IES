import "package:flutter_test/flutter_test.dart";
import "package:saludmovil_ies/app.dart";
import "package:saludmovil_ies/core/di/injection.dart";

void main() {
  testWidgets("Muestra la pantalla de inicio de sesión", (tester) async {
    setupDependencies();
    await tester.pumpWidget(const SaludMovilApp());
    await tester.pumpAndSettle();
    expect(find.text("Salud Movil IES"), findsOneWidget);
    expect(find.text("INGRESAR"), findsOneWidget);
  });
}
