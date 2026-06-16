import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/channel_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final ChannelRepository _channelRepo;
  final UserRepository _userRepo;

  PlayerBloc(this._channelRepo, this._userRepo) : super(PlayerInitial()) {
    on<LoadStreams>(_onLoadStreams);
    on<SelectQuality>(_onSelectQuality);
    on<ReportStream>(_onReportStream);
  }

  Future<void> _onLoadStreams(LoadStreams event, Emitter<PlayerState> emit) async {
    emit(PlayerLoading());
    try {
      final channel = await _channelRepo.getChannel(event.channelId);
      final streams = channel.streams;
      if (streams.isEmpty) {
        emit(const PlayerError('No streams available for this channel.'));
        return;
      }
      final active = streams.firstWhere((s) => s.isLive, orElse: () => streams.first);
      emit(PlayerReady(channel: channel, streams: streams, activeStream: active));

      // Log to history (fire and forget)
      _userRepo.addToHistory(event.channelId).catchError((_) {});
    } catch (e) {
      emit(PlayerError('Failed to load channel: ${e.toString()}'));
    }
  }

  void _onSelectQuality(SelectQuality event, Emitter<PlayerState> emit) {
    final current = state;
    if (current is PlayerReady) {
      emit(current.copyWith(activeStream: event.stream));
    }
  }

  Future<void> _onReportStream(ReportStream event, Emitter<PlayerState> emit) async {
    try {
      await _userRepo.reportStream(event.streamId, event.reason);
    } catch (_) {}
  }
}
