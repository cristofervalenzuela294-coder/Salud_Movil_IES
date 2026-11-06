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

  @override
  List<Object?> get props => [id, specialty, sede, date, time, confirmed];
}
