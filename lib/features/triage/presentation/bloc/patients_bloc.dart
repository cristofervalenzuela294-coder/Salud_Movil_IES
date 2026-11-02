import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';

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
  });
  final List<Patient> patients;
  final Patient? selected;
  final bool loading;
  final bool syncing;

  int get pending => patients.where((p) => !p.synced).length;

  PatientsState copyWith({
    List<Patient>? patients,
    Patient? selected,
    bool? loading,
    bool? syncing,
  }) =>
      PatientsState(
        patients: patients ?? this.patients,
        selected: selected ?? this.selected,
        loading: loading ?? this.loading,
        syncing: syncing ?? this.syncing,
      );

  @override
  List<Object?> get props => [patients, selected, loading, syncing];
}

/// Lista de pacientes ordenada por prioridad, con estado de sincronización.
class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  PatientsBloc(this._repository) : super(const PatientsState()) {
    on<PatientsRequested>((e, emit) async => emit(
        state.copyWith(patients: _sorted(await _repository.getAll()), loading: false)));
    on<PatientSaved>((e, emit) async {
      await _repository.add(e.patient);
      emit(state.copyWith(patients: _sorted(await _repository.getAll())));
    });
    on<PatientSelected>((e, emit) => emit(state.copyWith(selected: e.patient)));
    on<SyncRequested>(_onSync);
    add(const PatientsRequested());
  }

  final PatientRepository _repository;

  List<Patient> _sorted(List<Patient> list) {
    final copy = [...list];
    copy.sort((a, b) {
      final byLevel = a.level.index.compareTo(b.level.index);
      return byLevel != 0 ? byLevel : a.name.compareTo(b.name);
    });
    return copy;
  }

  Future<void> _onSync(SyncRequested e, Emitter<PatientsState> emit) async {
    if (state.syncing || state.pending == 0) return;
    emit(state.copyWith(syncing: true));
    // Simulación. En el Hito 8 aquí se llama a la API REST.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    await _repository.markAllSynced();
    emit(state.copyWith(patients: _sorted(await _repository.getAll()), syncing: false));
  }
}
