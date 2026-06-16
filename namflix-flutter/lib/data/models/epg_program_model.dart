import '../../domain/entities/epg_program.dart';

class EpgProgramModel extends EpgProgram {
  const EpgProgramModel({
    required super.id,
    required super.channelId,
    required super.title,
    super.description,
    required super.startTime,
    required super.endTime,
  });

  factory EpgProgramModel.fromJson(Map<String, dynamic> json) => EpgProgramModel(
    id:          json['id'] as String? ?? '',
    channelId:   json['channel_id'] as String? ?? '',
    title:       json['title'] as String? ?? '',
    description: json['description'] as String?,
    startTime:   DateTime.parse(json['start_time'] as String).toLocal(),
    endTime:     DateTime.parse(json['end_time'] as String).toLocal(),
  );
}
