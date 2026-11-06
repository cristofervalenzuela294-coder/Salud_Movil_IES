import 'package:equatable/equatable.dart';

class VitalSigns extends Equatable {
  const VitalSigns({
    required this.systolic,
    required this.diastolic,
    required this.spo2,
    required this.heartRate,
    required this.pain,
  });
  final int systolic;
  final int diastolic;
  final int spo2;
  final int heartRate;
  final int pain;

  String get pressureText => '$systolic/$diastolic';

  @override
  List<Object?> get props => [systolic, diastolic, spo2, heartRate, pain];
}
