import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Sede extends Equatable {
  const Sede({
    required this.id,
    required this.name,
    required this.specialties,
    required this.latitude,
    required this.longitude,
  });
  final String id;
  final String name;
  final List<String> specialties;
  final double latitude;
  final double longitude;

  LatLng get position => LatLng(latitude, longitude);

  @override
  List<Object?> get props => [id, name, specialties, latitude, longitude];
}
