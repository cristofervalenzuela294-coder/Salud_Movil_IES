import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../../domain/usecases/sync_patients.dart';

abstract class PatientsEvent extends Equatable {
  const PatientsEvent();
  @override
  List<Object?> get props => [];
}

class PatientsRequested extends PatientsEvent {
  const PatientsRequested();
}

class PatientSaved extends PatientsEvent {
  const PatientSaved(this.patient);
  final Patient patient;
  @override
  List<Object?> get props => [patient];
}

class PatientUpdated extends PatientsEvent {
  const PatientUpdated(this.patient);
  final Patient patient;
  @override
  List<Object?> get props => [patient];
}

class PatientDeleted extends PatientsEvent {
  const PatientDeleted(this.patient);
  final Patient patient;
  @override
  List<Object?> get props => [patient];
}

class PatientSelected extends PatientsEvent {
  const PatientSelected(this.patient);
  final Patient patient;
  @override
  List<Object?> get props => [patient];
}

class SyncRequested extends PatientsEvent {
  const SyncRequested();
}

class PatientsState extends Equatable {
  const PatientsState({
    this.patients = const [],
    this.selected,
    this.loading = true,
    this.syncing = false,
    this.syncMessage,
  });
  final List<Patient> patients;
  final Patient? selected;
  final bool loading;
  final bool syncing;

  /// Resultado o error de la última sincronización (para mostrar al usuario).
  final String? syncMessage;

  int get pending => patients.where((p) => !p.synced).length;

  PatientsState copyWith({
    List<Patient>? patients,
    Patient? selected,
    bool clearSelected = false,
    bool? loading,
    bool? syncing,
    String? syncMessage,
    bool clearMessage = false,
  }) =>
      PatientsState(
        patients: patients ?? this.patients,
        selected: clearSelected ? null : (selected ?? this.selected),
        loading: loading ?? this.loading,
        syncing: syncing ?? this.syncing,
        syncMessage: clearMessage ? null : (syncMessage ?? this.syncMessage),
      );

  @override
  List<Object?> get props => [patients, selected, loading, syncing, syncMessage];
}

/// CRUD de fichas con orden por prioridad y sincronización con el servidor.
class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  PatientsBloc(this._repository, {SyncPatients? sync})
      : _sync = sync,
        super(const PatientsState()) {
    on<PatientsRequested>((e, emit) async => emit(
        state.copyWith(patients: _sorted(await _repository.getAll()), loading: false)));
    on<PatientSaved>((e, emit) async {
      await _repository.add(e.patient);
      emit(state.copyWith(patients: _sorted(await _repository.getAll())));
    });
    on<PatientUpdated>((e, emit) async {
      await _repository.update(e.patient);
      emit(state.copyWith(
          patients: _sorted(await _repository.getAll()), selected: e.patient));
    });
    on<PatientDeleted>((e, emit) async {
      final id = e.patient.id;
      if (id == null) return;
      await _repository.delete(id);
      emit(state.copyWith(
          patients: _sorted(await _repository.getAll()), clearSelected: true));
    });
    on<PatientSelected>((e, emit) => emit(state.copyWith(selected: e.patient)));
    on<SyncRequested>(_onSync);
    add(const PatientsRequested());
  }

  final PatientRepository _repository;
  final SyncPatients? _sync;

  List<Patient> _sorted(List<Patient> list) {
    final copy = [...list];
    copy.sort((a, b) {
      final byLevel = a.level.index.compareTo(b.level.index);
      return byLevel != 0 ? byLevel : a.name.compareTo(b.name);
    });
    return copy;
  }

  Future<void> _onSync(SyncRequested e, Emitter<PatientsState> emit) async {
    if (state.syncing) return;
    final sync = _sync;
    if (sync == null) {
      // Sin servicio web (pruebas): se marcan como enviadas en local.
      if (state.pending == 0) return;
      emit(state.copyWith(syncing: true));
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await _repository.markAllSynced();
      emit(state.copyWith(patients: _sorted(await _repository.getAll()), syncing: false));
      return;
    }
    emit(state.copyWith(syncing: true, clearMessage: true));
    try {
      final result = await sync();
      emit(state.copyWith(
        patients: _sorted(await _repository.getAll()),
        syncing: false,
        syncMessage: result.summary,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(
        patients: _sorted(await _repository.getAll()),
        syncing: false,
        syncMessage: f.message,
      ));
    } catch (_) {
      emit(state.copyWith(syncing: false, syncMessage: 'Error inesperado al sincronizar'));
    }
  }
}
