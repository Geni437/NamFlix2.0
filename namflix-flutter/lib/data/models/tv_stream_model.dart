import '../../domain/entities/tv_stream.dart';

class TvStreamModel extends TvStream {
  const TvStreamModel({
    required super.id,
    required super.channelId,
    required super.url,
    super.quality,
    super.isLive,
    super.isGeoBlocked,
    super.failureReason,
    super.userAgent,
    super.referrer,
  });

  factory TvStreamModel.fromJson(Map<String, dynamic> json) {
    return TvStreamModel(
      id:            json['id'] as String? ?? '',
      channelId:     json['channel_id'] as String? ?? '',
      url:           json['url'] as String? ?? '',
      quality:       json['quality'] as String?,
      isLive:        (json['is_live'] as int? ?? 0) == 1,
      isGeoBlocked:  (json['is_geo_blocked'] as int? ?? 0) == 1,
      failureReason: json['failure_reason'] as String?,
      userAgent:     json['user_agent'] as String?,
      referrer:      json['referrer'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'channel_id': channelId,
    'url': url,
    'quality': quality,
    'is_live': isLive ? 1 : 0,
    'is_geo_blocked': isGeoBlocked ? 1 : 0,
    'failure_reason': failureReason,
    'user_agent': userAgent,
    'referrer': referrer,
  };
}
