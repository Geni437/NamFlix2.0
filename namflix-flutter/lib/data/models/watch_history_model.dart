import '../../domain/entities/watch_history_item.dart';

class WatchHistoryModel extends WatchHistoryItem {
  const WatchHistoryModel({
    required super.channelId,
    super.channelName,
    super.logoUrl,
    super.country,
    required super.watchedAt,
  });

  factory WatchHistoryModel.fromJson(Map<String, dynamic> json) => WatchHistoryModel(
    channelId:   json['channel_id'] as String? ?? '',
    channelName: json['channel_name'] as String?,
    logoUrl:     json['logo_url'] as String?,
    country:     json['country'] as String?,
    watchedAt:   DateTime.parse(json['watched_at'] as String).toLocal(),
  );
}
