/// Token de la sesión actual (en memoria).
class AuthSession {
  String? token;
  bool get isAuthenticated => token != null;
}
