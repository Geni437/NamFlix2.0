import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class ToggleFavorite extends FavoritesEvent {
  final String channelId;
  final bool currentlyFavorited;
  const ToggleFavorite(this.channelId, {required this.currentlyFavorited});
  @override
  List<Object?> get props => [channelId];
}

class RemoveFavorite extends FavoritesEvent {
  final String channelId;
  const RemoveFavorite(this.channelId);
  @override
  List<Object?> get props => [channelId];
}
