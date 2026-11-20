import '../../../../core/error/failures.dart';
import '../repositories/patient_remote.dart';
import '../repositories/patient_repository.dart';

class SyncResult {
  const SyncResult({this.pushed = 0, this.pulled = 0, this.failed = 0});
  final int pushed;
  final int pulled;
  final int failed;

  String get summary {
    final base = 'Enviadas: $pushed · Descargadas: $pulled';
    return failed > 0 ? '$base · Con error: $failed' : base;
  }
}

/// Sincroniza fichas: envía las pendientes (POST o PUT) y descarga las nuevas (GET).
class SyncPatients {
  SyncPatients(this._local, this._remote);
  final PatientRepository _local;
  final PatientRemote _remote;

  Future<SyncResult> call() async {
    var pushed = 0;
    var failed = 0;
    var pulled = 0;

    final pending = (await _local.getAll()).where((p) => !p.synced);
    for (final p in pending) {
      try {
        final remoteId = p.remoteId;
        if (remoteId == null) {
          final newId = await _remote.create(p);
          await _local.update(p.copyWith(remoteId: newId, synced: true));
        } else {
          await _remote.update(remoteId, p);
          await _local.update(p.copyWith(synced: true));
        }
        pushed++;
      } on NetworkFailure {
        rethrow; // sin red no tiene sentido seguir intentando
      } on TimeoutFailure {
        rethrow;
      } on UnauthorizedFailure {
        rethrow;
      } on Failure {
        failed++; // error con esta ficha: se sigue con las demás
      }
    }

    final knownIds =
        (await _local.getAll()).map((p) => p.remoteId).whereType<int>().toSet();
    for (final remote in await _remote.fetchAll()) {
      if (!knownIds.contains(remote.remoteId)) {
        await _local.add(remote);
        pulled++;
      }
    }
    return SyncResult(pushed: pushed, pulled: pulled, failed: failed);
  }
}
