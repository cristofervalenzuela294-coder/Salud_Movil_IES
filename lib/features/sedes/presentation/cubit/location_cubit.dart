import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/location/location_service.dart';

enum LocationStatus { initial, loading, ready, error }

class LocationState extends Equatable {
  const LocationState({this.status = LocationStatus.initial, this.position, this.message});
  final LocationStatus status;
  final LatLng? position;
  final String? message;

  @override
  List<Object?> get props => [status, position, message];
}

/// Ubicación del usuario en tiempo real.
class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._service) : super(const LocationState());

  final LocationService _service;
  StreamSubscription<LatLng>? _sub;

  /// Obtiene la posición y empieza a escucharla. Con [force] reintenta aunque ya haya una.
  Future<void> start({bool force = false}) async {
    if (!force &&
        (state.status == LocationStatus.ready || state.status == LocationStatus.loading)) {
      return;
    }
    emit(const LocationState(status: LocationStatus.loading));
    try {
      final first = await _service.current();
      emit(LocationState(status: LocationStatus.ready, position: first));
      await _sub?.cancel();
      _sub = _service.watch().listen(
            (p) => emit(LocationState(status: LocationStatus.ready, position: p)),
            onError: (_) => emit(const LocationState(
                status: LocationStatus.error, message: 'Se perdió la señal del GPS')),
          );
    } on LocationFailure catch (f) {
      emit(LocationState(status: LocationStatus.error, message: f.message));
    } catch (_) {
      emit(const LocationState(
          status: LocationStatus.error, message: 'No se pudo obtener la ubicación'));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
