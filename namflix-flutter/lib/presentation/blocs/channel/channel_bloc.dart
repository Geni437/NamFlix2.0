import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/channel_repository.dart';
import 'channel_event.dart';
import 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository _repo;

  int _currentPage = 1;
  LoadChannels? _lastFilters;

  ChannelBloc(this._repo) : super(ChannelInitial()) {
    on<LoadChannels>(_onLoadChannels);
    on<LoadMoreChannels>(_onLoadMore);
    on<RefreshChannels>(_onRefresh);
  }

  Future<void> _onLoadChannels(LoadChannels event, Emitter<ChannelState> emit) async {
    _lastFilters = event;
    _currentPage = 1;
    emit(ChannelLoading());
    try {
      final result = await _repo.getChannels(
        search: event.search,
        country: event.country,
        language: event.language,
        categories: event.categories,
        liveOnly: event.liveOnly,
        quality: event.quality,
        sort: event.sort,
        page: 1,
      );
      emit(ChannelLoaded(
        channels: result.channels,
        total: result.total,
        hasMore: result.hasMore,
      ));
    } catch (e) {
      emit(ChannelError(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreChannels event, Emitter<ChannelState> emit) async {
    final current = state;
    if (current is! ChannelLoaded || !current.hasMore) return;

    emit(ChannelLoadingMore(currentChannels: current.channels, total: current.total));
    _currentPage++;

    try {
      final f = _lastFilters;
      final result = await _repo.getChannels(
        search: f?.search,
        country: f?.country,
        language: f?.language,
        categories: f?.categories,
        liveOnly: f?.liveOnly ?? false,
        quality: f?.quality,
        sort: f?.sort ?? 'name_asc',
        page: _currentPage,
      );
      emit(ChannelLoaded(
        channels: [...current.channels, ...result.channels],
        total: result.total,
        hasMore: result.hasMore,
      ));
    } catch (_) {
      emit(ChannelLoaded(
        channels: current.channels,
        total: current.total,
        hasMore: false,
      ));
    }
  }

  Future<void> _onRefresh(RefreshChannels event, Emitter<ChannelState> emit) async {
    if (_lastFilters != null) {
      add(_lastFilters!);
    } else {
      add(const LoadChannels());
    }
  }
}
