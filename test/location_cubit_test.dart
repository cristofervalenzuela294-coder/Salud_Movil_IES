import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:saludmovil_ies/core/error/failures.dart';
import 'package:saludmovil_ies/core/location/location_service.dart';
import 'package:saludmovil_ies/features/sedes/presentation/cubit/location_cubit.dart';

class _FakeLocation implements LocationService {
  _FakeLocation({this.initial, this.error});
  final LatLng? initial;
  final LocationFailure? error;
  final controller = StreamController<LatLng>.broadcast();

  @override
  Future<LatLng> current() async {
    if (error != null) throw error!;
    return initial!;
  }

  @override
  Stream<LatLng> watch() => controller.stream;
}

void main() {
  test('obtiene la posición y la actualiza en tiempo real', () async {
    final svc = _FakeLocation(initial: const LatLng(-14.83, -74.93));
    final cubit = LocationCubit(svc);

    await cubit.start();
    expect(cubit.state.status, LocationStatus.ready);
    expect(cubit.state.position, const LatLng(-14.83, -74.93));

    svc.controller.add(const LatLng(-14.84, -74.94));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.position, const LatLng(-14.84, -74.94));
    await cubit.close();
  });

  test('si el GPS falla, expone el mensaje de error', () async {
    final cubit = LocationCubit(
        _FakeLocation(error: const LocationFailure('Active el GPS del dispositivo')));
    await cubit.start();
    expect(cubit.state.status, LocationStatus.error);
    expect(cubit.state.message, 'Active el GPS del dispositivo');
    expect(cubit.state.position, isNull);
    await cubit.close();
  });
}
