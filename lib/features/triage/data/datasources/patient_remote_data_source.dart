import 'package:dio/dio.dart';

import '../../../../core/network/dio_failure.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_remote.dart';
import '../models/patient_remote_model.dart';

/// Cliente REST de fichas (POST, PUT y GET sobre `/patients`).
class PatientRemoteDataSource implements PatientRemote {
  PatientRemoteDataSource(this._dio);
  final Dio _dio;

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw failureFromDio(e);
    }
  }

  @override
  Future<int> create(Patient patient) => _guard(() async {
        final res = await _dio.post('/patients', data: PatientRemoteModel.toJson(patient));
        return (res.data['id'] as num).toInt();
      });

  @override
  Future<void> update(int remoteId, Patient patient) => _guard(() async {
        await _dio.put('/patients/$remoteId', data: PatientRemoteModel.toJson(patient));
      });

  @override
  Future<List<Patient>> fetchAll() => _guard(() async {
        final res = await _dio.get('/patients');
        return (res.data as List)
            .map((e) => PatientRemoteModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });
}
