import 'package:dio/dio.dart';
import '../models/channel_model.dart';
import '../models/user_profile_model.dart';
import '../models/watch_history_model.dart';

class RemoteUserDataSource {
  final Dio _dio;
  RemoteUserDataSource(this._dio);

  Future<UserProfileModel> getProfile() async {
    final response = await _dio.get('/me');
    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateProfile({
    String? preferredCountry,
    String? preferredLanguage,
    List<String>? preferredCategories,
  }) async {
    await _dio.put('/me', data: {
      if (preferredCountry != null) 'preferred_country': preferredCountry,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (preferredCategories != null) 'preferred_categories': preferredCategories,
    });
  }

  Future<List<ChannelModel>> getFavorites() async {
    final response = await _dio.get('/me/favorites');
    final body = response.data as Map<String, dynamic>;
    final list = (body['channels'] ?? body['data'] ?? []) as List<dynamic>;
    return list.map((j) => ChannelModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> addFavorite(String channelId) async {
    await _dio.post('/me/favorites', data: {'channel_id': channelId});
  }

  Future<void> removeFavorite(String channelId) async {
    await _dio.delete('/me/favorites/$channelId');
  }

  Future<List<WatchHistoryModel>> getHistory() async {
    final response = await _dio.get('/me/history');
    final body = response.data as Map<String, dynamic>;
    final list = (body['history'] ?? body['data'] ?? []) as List<dynamic>;
    return list.map((j) => WatchHistoryModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> addToHistory(String channelId) async {
    try {
      await _dio.post('/me/history', data: {'channel_id': channelId});
    } catch (_) {}
  }

  Future<void> reportStream(String streamId, String reason) async {
    await _dio.post('/stream-reports', data: {'stream_id': streamId, 'reason': reason});
  }
}
