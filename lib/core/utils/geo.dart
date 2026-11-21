import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Distancia en kilómetros entre dos coordenadas (fórmula de Haversine).
double distanceKm(LatLng a, LatLng b) {
  const earthRadiusKm = 6371.0;
  double rad(double deg) => deg * math.pi / 180;
  final dLat = rad(b.latitude - a.latitude);
  final dLng = rad(b.longitude - a.longitude);
  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(a.latitude)) *
          math.cos(rad(b.latitude)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * earthRadiusKm * math.asin(math.sqrt(h));
}

/// "850 m" si es menos de 1 km; "2.3 km" en otro caso.
String formatDistance(double km) {
  if (km < 1) return '${(km * 1000).round()} m';
  return '${km.toStringAsFixed(1)} km';
}
