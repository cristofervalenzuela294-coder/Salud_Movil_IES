import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

/// Citas del paciente, guardadas en el repositorio (SQLite en la app real).
class AppointmentsCubit extends Cubit<List<Appointment>> {
  AppointmentsCubit(this._repository) : super(const []) {
    load();
  }

  final AppointmentRepository _repository;

  Future<void> load() async => emit(await _repository.getAll());

  Future<void> add(Appointment a) async {
    await _repository.add(a);
    emit(await _repository.getAll());
  }
}
