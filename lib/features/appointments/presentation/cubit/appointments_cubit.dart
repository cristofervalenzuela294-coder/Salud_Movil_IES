import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment.dart';

/// Citas del paciente. En los Hitos 6 y 8 se conecta a SQLite y a la API.
class AppointmentsCubit extends Cubit<List<Appointment>> {
  AppointmentsCubit()
      : super(const [
          Appointment(
              specialty: 'Medicina general',
              sede: 'Sede Principal',
              date: '03/11/2026',
              time: '10:30',
              confirmed: true),
          Appointment(
              specialty: 'Pediatría',
              sede: 'Ambulatorio Norte',
              date: '05/11/2026',
              time: '09:00'),
        ]);

  void add(Appointment a) => emit([...state, a]);
}
