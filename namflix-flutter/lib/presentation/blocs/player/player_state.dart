import 'package:equatable/equatable.dart';
import '../../../domain/entities/channel.dart';
import '../../../domain/entities/tv_stream.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();
  @override
  List<Object?> get props => [];
}

class PlayerInitial extends PlayerState {}
class PlayerLoading extends PlayerState {}

class PlayerReady extends PlayerState {
  final Channel channel;
  final List<TvStream> streams;
  final TvStream activeStream;

  const PlayerReady({
    required this.channel,
    required this.streams,
    required this.activeStream,
  });

  PlayerReady copyWith({TvStream? activeStream}) => PlayerReady(
    channel: channel,
    streams: streams,
    activeStream: activeStream ?? this.activeStream,
  );

  @override
  List<Object?> get props => [channel.id, activeStream.id];
}

class PlayerError extends PlayerState {
  final String message;
  const PlayerError(this.message);
  @override
  List<Object?> get props => [message];
}
