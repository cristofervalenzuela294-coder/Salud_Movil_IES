import 'package:equatable/equatable.dart';

/// Datos de admisión capturados antes de tomar los signos vitales.
class PatientDraft extends Equatable {
  const PatientDraft({
    required this.dni,
    required this.name,
    required this.age,
    required this.reason,
  });
  final String dni;
  final String name;
  final int age;
  final String reason;

  String get label => '$name · $age años';

  @override
  List<Object?> get props => [dni, name, age, reason];
}
