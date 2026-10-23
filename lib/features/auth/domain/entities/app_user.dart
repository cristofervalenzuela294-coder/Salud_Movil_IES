import "package:equatable/equatable.dart";

enum UserRole { enfermeria, medico, paciente }

class AppUser extends Equatable {
  const AppUser({required this.username, required this.role});
  final String username;
  final UserRole role;

  @override
  List<Object?> get props => [username, role];
}
