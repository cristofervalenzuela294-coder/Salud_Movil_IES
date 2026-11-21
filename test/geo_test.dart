import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:saludmovil_ies/core/utils/geo.dart';

void main() {
  test('la distancia entre el mismo punto es 0', () {
    const p = LatLng(-14.83, -74.93);
    expect(distanceKm(p, p), closeTo(0, 0.0001));
  });

  test('un grado de latitud son unos 111 km', () {
    final d = distanceKm(const LatLng(-14.0, -74.93), const LatLng(-15.0, -74.93));
    expect(d, closeTo(111.2, 0.5));
  });

  test('la distancia es simétrica', () {
    const a = LatLng(-14.83, -74.93);
    const b = LatLng(-14.85, -74.90);
    expect(distanceKm(a, b), closeTo(distanceKm(b, a), 0.0001));
  });

  test('formato de distancia', () {
    expect(formatDistance(0.85), '850 m');
    expect(formatDistance(2.34), '2.3 km');
  });
}
