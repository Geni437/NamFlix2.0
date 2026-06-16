import 'package:equatable/equatable.dart';
import '../../../domain/entities/tv_stream.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
  @override
  List<Object?> get props => [];
}

class LoadStreams extends PlayerEvent {
  final String channelId;
  const LoadStreams(this.channelId);
  @override
  List<Object?> get props => [channelId];
}

class SelectQuality extends PlayerEvent {
  final TvStream stream;
  const SelectQuality(this.stream);
  @override
  List<Object?> get props => [stream.id];
}

class ReportStream extends PlayerEvent {
  final String streamId;
  final String reason;
  const ReportStream(this.streamId, this.reason);
  @override
  List<Object?> get props => [streamId, reason];
}
