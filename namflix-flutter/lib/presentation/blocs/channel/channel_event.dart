import 'package:equatable/equatable.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();
  @override
  List<Object?> get props => [];
}

class LoadChannels extends ChannelEvent {
  final String? search;
  final String? country;
  final String? language;
  final List<String>? categories;
  final bool liveOnly;
  final String? quality;
  final String sort;

  const LoadChannels({
    this.search,
    this.country,
    this.language,
    this.categories,
    this.liveOnly = false,
    this.quality,
    this.sort = 'name_asc',
  });

  @override
  List<Object?> get props => [search, country, language, categories, liveOnly, quality, sort];
}

class LoadMoreChannels extends ChannelEvent {
  const LoadMoreChannels();
}

class RefreshChannels extends ChannelEvent {
  const RefreshChannels();
}
