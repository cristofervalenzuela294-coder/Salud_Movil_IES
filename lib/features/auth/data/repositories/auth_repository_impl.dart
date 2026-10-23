import "../../domain/entities/app_user.dart";
import "../../domain/repositories/auth_repository.dart";

/// Implementación simulada. En el Hito 8 se reemplaza por la API REST.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<AppUser> login(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return AppUser(username: username, role: UserRole.enfermeria);
  }
}
