import 'package:equatable/equatable.dart';
import 'tv_stream.dart';

class Channel extends Equatable {
  final String id;
  final String name;
  final String? logoUrl;
  final String? country;
  final String? website;
  final List<String> categories;
  final List<TvStream> streams;
  final bool isHidden;

  const Channel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.country,
    this.website,
    this.categories = const [],
    this.streams = const [],
    this.isHidden = false,
  });

  bool get isLive => streams.any((s) => s.isLive);
  TvStream? get bestStream => streams.where((s) => s.isLive).firstOrNull ?? streams.firstOrNull;

  @override
  List<Object?> get props => [id, name, logoUrl, country, categories, isHidden];
}
