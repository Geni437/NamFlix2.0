import '../../domain/entities/channel.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/watch_history_item.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote_user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteUserDataSource _remote;
  UserRepositoryImpl(this._remote);

  @override
  Future<UserProfile> getProfile() => _remote.getProfile();

  @override
  Future<void> updateProfile({
    String? preferredCountry,
    String? preferredLanguage,
    List<String>? preferredCategories,
  }) => _remote.updateProfile(
    preferredCountry: preferredCountry,
    preferredLanguage: preferredLanguage,
    preferredCategories: preferredCategories,
  );

  @override
  Future<List<Channel>> getFavorites() => _remote.getFavorites();

  @override
  Future<void> addFavorite(String channelId) => _remote.addFavorite(channelId);

  @override
  Future<void> removeFavorite(String channelId) => _remote.removeFavorite(channelId);

  @override
  Future<List<WatchHistoryItem>> getHistory() => _remote.getHistory();

  @override
  Future<void> addToHistory(String channelId) => _remote.addToHistory(channelId);

  @override
  Future<void> reportStream(String streamId, String reason) => _remote.reportStream(streamId, reason);
}
