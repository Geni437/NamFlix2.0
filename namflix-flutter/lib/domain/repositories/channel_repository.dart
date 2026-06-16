import '../entities/channel.dart';
import '../entities/category.dart';
import '../entities/country.dart';

abstract class ChannelRepository {
  Future<({List<Channel> channels, int total, bool hasMore})> getChannels({
    String? search,
    String? country,
    String? language,
    List<String>? categories,
    bool liveOnly = false,
    String? quality,
    String sort = 'name_asc',
    int page = 1,
    int limit = 48,
  });

  Future<Channel> getChannel(String id);
  Future<List<Channel>> getTrending({int limit = 20});
  Future<List<Channel>> searchChannels(String query);
  Future<List<Category>> getCategories();
  Future<List<Country>> getCountries();
  Future<List<Country>> getLanguages();
}
