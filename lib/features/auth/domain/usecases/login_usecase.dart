import "../entities/app_user.dart";
import "../repositories/auth_repository.dart";

class LoginUseCase {
  LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<AppUser> call(String username, String password) {
    if (username.trim().isEmpty || password.isEmpty) {
      throw ArgumentError("Ingrese usuario y contraseña");
    }
    return _repository.login(username.trim(), password);
  }
}
