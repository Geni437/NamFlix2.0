import 'package:dio/dio.dart';
import '../models/channel_model.dart';
import '../models/category_model.dart';
import '../models/country_model.dart';

class RemoteChannelDataSource {
  final Dio _dio;
  RemoteChannelDataSource(this._dio);

  Future<({List<ChannelModel> channels, int total})> getChannels({
    String? search,
    String? country,
    String? language,
    List<String>? categories,
    bool liveOnly = false,
    String? quality,
    String sort = 'name_asc',
    int page = 1,
    int limit = 48,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (country != null && country.isNotEmpty) params['country'] = country;
    if (language != null && language.isNotEmpty) params['language'] = language;
    if (categories != null && categories.isNotEmpty) params['categories'] = categories.join(',');
    if (liveOnly) params['live_only'] = 'true';
    if (quality != null && quality.isNotEmpty) params['quality'] = quality;
    if (sort.isNotEmpty) params['sort'] = sort;

    final response = await _dio.get('/channels', queryParameters: params);
    final body = response.data as Map<String, dynamic>;

    final list = (body['channels'] ?? body['data'] ?? []) as List<dynamic>;
    final total = (body['total'] ?? body['meta']?['total'] ?? list.length) as int;

    return (
      channels: list.map((j) => ChannelModel.fromJson(j as Map<String, dynamic>)).toList(),
      total: total,
    );
  }

  Future<ChannelModel> getChannel(String id) async {
    final response = await _dio.get('/channels/$id');
    final body = response.data as Map<String, dynamic>;
    return ChannelModel.fromJson((body['channel'] ?? body) as Map<String, dynamic>);
  }

  Future<List<ChannelModel>> getTrending({int limit = 20}) async {
    final response = await _dio.get('/trending', queryParameters: {'limit': limit});
    final body = response.data as Map<String, dynamic>;
    final list = (body['channels'] ?? body['data'] ?? []) as List<dynamic>;
    return list.map((j) => ChannelModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<ChannelModel>> searchChannels(String query) async {
    final response = await _dio.get('/search', queryParameters: {'q': query});
    final body = response.data as Map<String, dynamic>;
    final list = (body['channels'] ?? body['data'] ?? []) as List<dynamic>;
    return list.map((j) => ChannelModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/categories');
    final list = (response.data as List<dynamic>? ?? []);
    return list.map((j) => CategoryModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<CountryModel>> getCountries() async {
    final response = await _dio.get('/countries');
    final list = (response.data as List<dynamic>? ?? []);
    return list.map((j) => CountryModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<CountryModel>> getLanguages() async {
    final response = await _dio.get('/languages');
    final list = (response.data as List<dynamic>? ?? []);
    return list.map((j) => CountryModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}
