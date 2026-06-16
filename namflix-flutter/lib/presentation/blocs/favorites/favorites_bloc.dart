import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/channel.dart';
import '../../../domain/repositories/user_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final UserRepository _repo;

  FavoritesBloc(this._repo) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoad);
    on<ToggleFavorite>(_onToggle);
    on<RemoveFavorite>(_onRemove);
  }

  Future<void> _onLoad(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final channels = await _repo.getFavorites();
      emit(FavoritesLoaded(channels));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onToggle(ToggleFavorite event, Emitter<FavoritesState> emit) async {
    final current = state;
    if (current is! FavoritesLoaded) return;

    final isNowFav = !event.currentlyFavorited;
    List<Channel> updated;

    if (isNowFav) {
      await _repo.addFavorite(event.channelId);
      updated = current.channels; // refresh on next load
    } else {
      await _repo.removeFavorite(event.channelId);
      updated = current.channels.where((c) => c.id != event.channelId).toList();
    }
    emit(FavoritesLoaded(updated));
  }

  Future<void> _onRemove(RemoveFavorite event, Emitter<FavoritesState> emit) async {
    final current = state;
    if (current is! FavoritesLoaded) return;
    await _repo.removeFavorite(event.channelId);
    final updated = current.channels.where((c) => c.id != event.channelId).toList();
    emit(FavoritesLoaded(updated));
  }
}
