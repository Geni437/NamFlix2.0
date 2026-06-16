import '../entities/user_profile.dart';
import '../entities/channel.dart';
import '../entities/watch_history_item.dart';

abstract class UserRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile({String? preferredCountry, String? preferredLanguage, List<String>? preferredCategories});
  Future<List<Channel>> getFavorites();
  Future<void> addFavorite(String channelId);
  Future<void> removeFavorite(String channelId);
  Future<List<WatchHistoryItem>> getHistory();
  Future<void> addToHistory(String channelId);
  Future<void> reportStream(String streamId, String reason);
}
