import 'package:equatable/equatable.dart';
import '../../../domain/entities/channel.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}
class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Channel> channels;
  final Set<String> favoriteIds;

  FavoritesLoaded(this.channels)
      : favoriteIds = channels.map((c) => c.id).toSet();

  bool isFavorite(String channelId) => favoriteIds.contains(channelId);

  @override
  List<Object?> get props => [channels];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object?> get props => [message];
}
