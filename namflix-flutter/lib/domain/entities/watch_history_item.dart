import 'package:equatable/equatable.dart';

class WatchHistoryItem extends Equatable {
  final String channelId;
  final String? channelName;
  final String? logoUrl;
  final String? country;
  final DateTime watchedAt;

  const WatchHistoryItem({
    required this.channelId,
    this.channelName,
    this.logoUrl,
    this.country,
    required this.watchedAt,
  });

  @override
  List<Object?> get props => [channelId, watchedAt];
}
