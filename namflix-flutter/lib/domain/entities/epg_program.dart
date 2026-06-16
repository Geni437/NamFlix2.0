import 'package:equatable/equatable.dart';

class EpgProgram extends Equatable {
  final String id;
  final String channelId;
  final String title;
  final String? description;
  final String? category;
  final DateTime startTime;
  final DateTime endTime;

  const EpgProgram({
    required this.id,
    required this.channelId,
    required this.title,
    this.description,
    this.category,
    required this.startTime,
    required this.endTime,
  });

  factory EpgProgram.fromJson(Map<String, dynamic> json) {
    return EpgProgram(
      id: json['id']?.toString() ?? '',
      channelId: json['channel_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      startTime: DateTime.parse(json['start_time'] as String).toUtc(),
      endTime: DateTime.parse(json['end_time'] as String).toUtc(),
    );
  }

  double get progressPercent {
    final now = DateTime.now();
    if (now.isBefore(startTime)) return 0;
    if (now.isAfter(endTime)) return 1;
    final total = endTime.difference(startTime).inSeconds;
    final elapsed = now.difference(startTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  bool get isNow {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  @override
  List<Object?> get props => [id, channelId, title, startTime, endTime];
}
