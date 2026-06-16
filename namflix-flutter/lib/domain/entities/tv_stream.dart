import 'package:equatable/equatable.dart';

class TvStream extends Equatable {
  final String id;
  final String channelId;
  final String url;
  final String? quality;
  final bool isLive;
  final bool isGeoBlocked;
  final String? failureReason;
  final String? userAgent;
  final String? referrer;

  const TvStream({
    required this.id,
    required this.channelId,
    required this.url,
    this.quality,
    this.isLive = false,
    this.isGeoBlocked = false,
    this.failureReason,
    this.userAgent,
    this.referrer,
  });

  Map<String, String> get headers {
    final h = <String, String>{};
    if (userAgent != null) h['User-Agent'] = userAgent!;
    if (referrer != null) h['Referer'] = referrer!;
    return h;
  }

  @override
  List<Object?> get props => [id, url, quality, isLive];
}
