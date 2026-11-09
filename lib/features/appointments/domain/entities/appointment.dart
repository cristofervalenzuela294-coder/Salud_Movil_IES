import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  const Appointment({
    this.id,
    required this.specialty,
    required this.sede,
    required this.date,
    required this.time,
    this.confirmed = false,
  });
  final int? id;
  final String specialty;
  final String sede;
  final String date;
  final String time;
  final bool confirmed;

  Appointment copyWith({
    int? id,
    String? specialty,
    String? sede,
    String? date,
    String? time,
    bool? confirmed,
  }) =>
      Appointment(
        id: id ?? this.id,
        specialty: specialty ?? this.specialty,
        sede: sede ?? this.sede,
        date: date ?? this.date,
        time: time ?? this.time,
        confirmed: confirmed ?? this.confirmed,
      );

  @override
  List<Object?> get props => [id, specialty, sede, date, time, confirmed];
}
