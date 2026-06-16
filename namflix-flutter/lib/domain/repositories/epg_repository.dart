import '../entities/epg_program.dart';

abstract class EpgRepository {
  Future<List<EpgProgram>> getEpg(String channelId, {String? timezone});
}
