import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../error/failures.dart';
import 'location_service.dart';

/// Implementación con el paquete `geolocator` (GPS del dispositivo).
class GeolocatorLocationService implements LocationService {
  @override
  Future<LatLng> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationFailure('Active el GPS del dispositivo');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationFailure('Permiso de ubicación denegado');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure(
          'Permiso de ubicación bloqueado. Actívelo en los ajustes del dispositivo');
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return LatLng(pos.latitude, pos.longitude);
  }

  @override
  Stream<LatLng> watch() => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).map((p) => LatLng(p.latitude, p.longitude));
}
