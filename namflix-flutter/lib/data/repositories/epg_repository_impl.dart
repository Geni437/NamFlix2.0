import 'package:dio/dio.dart';
import '../../domain/entities/epg_program.dart';
import '../../domain/repositories/epg_repository.dart';
import '../models/epg_program_model.dart';

class EpgRepositoryImpl implements EpgRepository {
  final Dio _dio;
  EpgRepositoryImpl(this._dio);

  @override
  Future<List<EpgProgram>> getEpg(String channelId, {String? timezone}) async {
    try {
      final params = <String, dynamic>{};
      if (timezone != null) params['timezone'] = timezone;
      final response = await _dio.get('/epg/$channelId', queryParameters: params);
      final body = response.data as Map<String, dynamic>;
      final list = (body['programs'] ?? body['data'] ?? []) as List<dynamic>;
      return list.map((j) => EpgProgramModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
