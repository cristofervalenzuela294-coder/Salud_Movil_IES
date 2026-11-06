import '../../domain/entities/appointment.dart';

class AppointmentModel {
  static Map<String, Object?> toMap(Appointment a) => {
        if (a.id != null) 'id': a.id,
        'specialty': a.specialty,
        'sede': a.sede,
        'date': a.date,
        'time': a.time,
        'confirmed': a.confirmed ? 1 : 0,
      };

  static Appointment fromMap(Map<String, Object?> m) => Appointment(
        id: m['id'] as int?,
        specialty: m['specialty'] as String,
        sede: m['sede'] as String,
        date: m['date'] as String,
        time: m['time'] as String,
        confirmed: (m['confirmed'] as int) == 1,
      );
}
