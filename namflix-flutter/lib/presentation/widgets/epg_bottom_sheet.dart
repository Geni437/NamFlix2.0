import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import '../../core/network/dio_client.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/epg_program.dart';

class EpgScheduleBottomSheet extends StatefulWidget {
  final String channelId;
  final String? channelName;

  const EpgScheduleBottomSheet({
    super.key,
    required this.channelId,
    this.channelName,
  });

  @override
  State<EpgScheduleBottomSheet> createState() => _EpgScheduleBottomSheetState();
}

class _EpgScheduleBottomSheetState extends State<EpgScheduleBottomSheet> {
  List<EpgProgram> _programs = [];
  bool _loading = true;
  String _tz = 'UTC';
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      _tz = await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      _tz = 'UTC';
    }

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await DioClient.instance.get(
        '/epg/${widget.channelId}',
        queryParameters: {'date': today, 'timezone': _tz},
      );
      final list = response.data?['data']?['programs'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() {
          _programs = list.map((j) => EpgProgram.fromJson(j as Map<String, dynamic>)).toList();
          _loading = false;
        });
        _scrollToCurrent();
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _scrollToCurrent() {
    final idx = _programs.indexWhere((p) => p.isNow);
    if (idx < 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          idx * 72.0, // approximate tile height
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime utcTime) => DateFormat('HH:mm').format(utcTime.toLocal());

  String _duration(EpgProgram p) {
    final mins = p.endTime.difference(p.startTime).inMinutes;
    final h    = mins ~/ 60;
    final m    = mins % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, sheetController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Today's Schedule${widget.channelName != null ? ' — ${widget.channelName}' : ''}",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            // Content
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accentBlue, strokeWidth: 2))
                  : _programs.isEmpty
                      ? const Center(
                          child: Text(
                            'No program guide available',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _programs.length,
                          itemBuilder: (_, index) => _ProgramTile(
                            program: _programs[index],
                            timeStr: _formatTime(_programs[index].startTime),
                            duration: _duration(_programs[index]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramTile extends StatelessWidget {
  final EpgProgram program;
  final String timeStr;
  final String duration;

  const _ProgramTile({
    required this.program,
    required this.timeStr,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final isPast    = !program.isNow && program.endTime.isBefore(DateTime.now().toUtc());
    final isCurrent = program.isNow;

    return Opacity(
      opacity: isPast ? 0.4 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.accentBlue.withOpacity(0.08) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isCurrent ? AppColors.accentBlue : Colors.transparent,
              width: 3,
            ),
            bottom: const BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time
                SizedBox(
                  width: 44,
                  child: Text(
                    timeStr,
                    style: TextStyle(
                      color: isCurrent ? AppColors.accentBlue : AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Title + category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCurrent)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'NOW',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                          ),
                        ),
                      Text(
                        program.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (program.category != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              program.category!,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Duration
                Text(
                  duration,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
            // Progress bar for current program
            if (isCurrent && program.progressPercent > 0) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: program.progressPercent,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                  minHeight: 3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
