import 'package:equatable/equatable.dart';
import '../../../domain/entities/channel.dart';

abstract class ChannelState extends Equatable {
  const ChannelState();
  @override
  List<Object?> get props => [];
}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelLoaded extends ChannelState {
  final List<Channel> channels;
  final int total;
  final bool hasMore;
  final bool isFromCache;

  const ChannelLoaded({
    required this.channels,
    required this.total,
    this.hasMore = false,
    this.isFromCache = false,
  });

  ChannelLoaded copyWith({
    List<Channel>? channels,
    int? total,
    bool? hasMore,
    bool? isFromCache,
  }) => ChannelLoaded(
    channels: channels ?? this.channels,
    total: total ?? this.total,
    hasMore: hasMore ?? this.hasMore,
    isFromCache: isFromCache ?? this.isFromCache,
  );

  @override
  List<Object?> get props => [channels, total, hasMore, isFromCache];
}

class ChannelLoadingMore extends ChannelState {
  final List<Channel> currentChannels;
  final int total;
  const ChannelLoadingMore({required this.currentChannels, required this.total});
  @override
  List<Object?> get props => [currentChannels];
}

class ChannelError extends ChannelState {
  final String message;
  const ChannelError(this.message);
  @override
  List<Object?> get props => [message];
}
