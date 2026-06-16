import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/channel_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ChannelRepository _repo;

  SearchBloc(this._repo) : super(SearchInitial()) {
    on<SearchChannels>(_onSearch);
    on<ClearSearch>(_onClear);
  }

  Future<void> _onSearch(SearchChannels event, Emitter<SearchState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final results = await _repo.searchChannels(event.query.trim());
      if (results.isEmpty) {
        emit(SearchEmpty(event.query));
      } else {
        emit(SearchLoaded(results, event.query));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClear(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
