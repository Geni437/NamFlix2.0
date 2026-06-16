import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/channel_model.dart';
import '../models/category_model.dart';
import '../models/country_model.dart';

class LocalChannelDataSource {
  final Box<String> _channelsBox;
  final Box<String> _categoriesBox;
  final Box<String> _countriesBox;

  LocalChannelDataSource(this._channelsBox, this._categoriesBox, this._countriesBox);

  String _cacheKey({
    String? search, String? country, String? language,
    List<String>? categories, bool liveOnly = false,
    String? quality, String sort = 'name_asc', int page = 1,
  }) {
    return 'ch_${search}_${country}_${language}_${categories?.join(',')}_${liveOnly}_${quality}_${sort}_$page';
  }

  Future<List<ChannelModel>?> getChannels({
    String? search, String? country, String? language,
    List<String>? categories, bool liveOnly = false,
    String? quality, String sort = 'name_asc', int page = 1,
  }) async {
    final key = _cacheKey(search: search, country: country, language: language,
        categories: categories, liveOnly: liveOnly, quality: quality, sort: sort, page: page);
    final json = _channelsBox.get(key);
    if (json == null) return null;
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((j) => ChannelModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> saveChannels(List<ChannelModel> channels, {
    String? search, String? country, String? language,
    List<String>? categories, bool liveOnly = false,
    String? quality, String sort = 'name_asc', int page = 1,
  }) async {
    final key = _cacheKey(search: search, country: country, language: language,
        categories: categories, liveOnly: liveOnly, quality: quality, sort: sort, page: page);
    await _channelsBox.put(key, jsonEncode(channels.map((c) => c.toJson()).toList()));
  }

  Future<List<CategoryModel>?> getCategories() async {
    final json = _categoriesBox.get('categories');
    if (json == null) return null;
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((j) => CategoryModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> saveCategories(List<CategoryModel> categories) async {
    await _categoriesBox.put('categories', jsonEncode(categories.map((c) => c.toJson()).toList()));
  }

  Future<List<CountryModel>?> getCountries() async {
    final json = _countriesBox.get('countries');
    if (json == null) return null;
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((j) => CountryModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> saveCountries(List<CountryModel> countries) async {
    await _countriesBox.put('countries', jsonEncode(countries.map((c) => c.toJson()).toList()));
  }

  Future<void> clear() async {
    await _channelsBox.clear();
    await _categoriesBox.clear();
    await _countriesBox.clear();
  }
}
