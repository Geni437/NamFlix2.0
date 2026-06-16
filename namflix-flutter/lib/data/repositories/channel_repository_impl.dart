import 'package:dio/dio.dart';
import '../../domain/entities/channel.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/channel_repository.dart';
import '../datasources/remote_channel_datasource.dart';
import '../datasources/local_channel_datasource.dart';
class ChannelRepositoryImpl implements ChannelRepository {
  final RemoteChannelDataSource _remote;
  final LocalChannelDataSource _local;

  ChannelRepositoryImpl(this._remote, this._local);

  @override
  Future<({List<Channel> channels, int total, bool hasMore})> getChannels({
    String? search, String? country, String? language,
    List<String>? categories, bool liveOnly = false,
    String? quality, String sort = 'name_asc', int page = 1, int limit = 48,
  }) async {
    try {
      final result = await _remote.getChannels(
        search: search, country: country, language: language,
        categories: categories, liveOnly: liveOnly,
        quality: quality, sort: sort, page: page, limit: limit,
      );
      await _local.saveChannels(result.channels,
        search: search, country: country, language: language,
        categories: categories, liveOnly: liveOnly,
        quality: quality, sort: sort, page: page,
      );
      return (channels: result.channels, total: result.total, hasMore: result.channels.length >= limit);
    } on DioException {
      final cached = await _local.getChannels(
        search: search, country: country, language: language,
        categories: categories, liveOnly: liveOnly,
        quality: quality, sort: sort, page: page,
      );
      if (cached != null) {
        return (channels: cached, total: cached.length, hasMore: false);
      }
      rethrow;
    }
  }

  @override
  Future<Channel> getChannel(String id) async {
    return _remote.getChannel(id);
  }

  @override
  Future<List<Channel>> getTrending({int limit = 20}) async {
    try {
      return await _remote.getTrending(limit: limit);
    } on DioException {
      final cached = await _local.getChannels(sort: 'name_asc', page: 1);
      return cached ?? [];
    }
  }

  @override
  Future<List<Channel>> searchChannels(String query) async {
    return _remote.searchChannels(query);
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final models = await _remote.getCategories();
      await _local.saveCategories(models);
      return models;
    } on DioException {
      return await _local.getCategories() ?? [];
    }
  }

  @override
  Future<List<Country>> getCountries() async {
    try {
      final models = await _remote.getCountries();
      await _local.saveCountries(models);
      return models;
    } on DioException {
      return await _local.getCountries() ?? [];
    }
  }

  @override
  Future<List<Country>> getLanguages() async {
    try {
      return await _remote.getLanguages();
    } on DioException {
      return [];
    }
  }
}
