import 'package:latlong2/latlong.dart';

/// Contrato del servicio de ubicación. Lanza `LocationFailure` si no se puede obtener.
abstract class LocationService {
  /// Pide permiso si hace falta y devuelve la posición actual.
  Future<LatLng> current();

  /// Posiciones en tiempo real (se emite al moverse unos metros).
  Stream<LatLng> watch();
}
