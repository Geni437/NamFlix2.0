import '../../domain/entities/channel.dart';
import 'tv_stream_model.dart';

class ChannelModel extends Channel {
  const ChannelModel({
    required super.id,
    required super.name,
    super.logoUrl,
    super.country,
    super.website,
    super.categories,
    super.streams,
    super.isHidden,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    final streamsList = (json['streams'] as List<dynamic>?)
        ?.map((s) => TvStreamModel.fromJson(s as Map<String, dynamic>))
        .toList() ?? [];

    final cats = <String>[];
    final rawCats = json['categories'];
    if (rawCats is List) {
      cats.addAll(rawCats.map((e) => e.toString()));
    } else if (rawCats is String && rawCats.isNotEmpty) {
      try {
        final decoded = rawCats.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
        cats.addAll(decoded.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
      } catch (_) {}
    }

    // Try logo from nested logos array
    String? logoUrl = json['logo_url'] as String?;
    if (logoUrl == null) {
      final logos = json['logos'] as List<dynamic>?;
      if (logos != null && logos.isNotEmpty) {
        logoUrl = (logos.first as Map<String, dynamic>)['url'] as String?;
      }
    }

    return ChannelModel(
      id:         json['id'] as String,
      name:       json['name'] as String? ?? '',
      logoUrl:    logoUrl,
      country:    json['country'] as String?,
      website:    json['website'] as String?,
      categories: cats,
      streams:    streamsList,
      isHidden:   (json['is_hidden'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'logo_url': logoUrl,
    'country': country,
    'website': website,
    'categories': categories,
    'is_hidden': isHidden ? 1 : 0,
  };
}
