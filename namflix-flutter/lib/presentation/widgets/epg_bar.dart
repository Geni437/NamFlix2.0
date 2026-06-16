import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import '../../core/network/dio_client.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/epg_program.dart';
import 'epg_bottom_sheet.dart';

class EpgBar extends StatefulWidget {
  final String channelId;
  final String? channelName;

  const EpgBar({super.key, required this.channelId, this.channelName});

  @override
  State<EpgBar> createState() => _EpgBarState();
}

class _EpgBarState extends State<EpgBar> {
  EpgProgram? _current;
  EpgProgram? _next;
  double _progress = 0;
  Timer? _timer;
  String _tz = 'UTC';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      _tz = await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      _tz = 'UTC';
    }
    await _fetchEpg();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateProgress());
  }

  Future<void> _fetchEpg() async {
    try {
      final response = await DioClient.instance.get(
        '/epg/${widget.channelId}',
        queryParameters: {'timezone': _tz},
      );
      final data = response.data?['data'];
      if (data == null) return;

      final currentJson = data['current_program'];
      final nextJson    = data['next_program'];

      if (mounted) {
        setState(() {
          _current = currentJson != null ? EpgProgram.fromJson(currentJson) : null;
          _next    = nextJson    != null ? EpgProgram.fromJson(nextJson)    : null;
        });
        _updateProgress();
      }
    } catch (_) {}
  }

  void _updateProgress() {
    if (_current == null || !mounted) return;
    final now     = DateTime.now();
    final start   = _current!.startTime;
    final end     = _current!.endTime;
    final total   = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds;
    setState(() {
      _progress = total > 0 ? (elapsed / total).clamp(0.0, 1.0) : 0;
    });
  }

  String _formatTime(DateTime utcTime) {
    final local = utcTime.toLocal();
    return DateFormat('HH:mm').format(local);
  }

  @override
  Widget build(BuildContext context) {
    if (_current == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showScheduleSheet(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOW badge + title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'NOW',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _current!.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: const Color(0xFF2A2A35),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 6),
            // Footer row
            Row(
              children: [
                Text(
                  'Ends ${_formatTime(_current!.endTime)}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
                if (_next != null) ...[
                  const Spacer(),
                  Flexible(
                    child: Text(
                      'Up Next: ${_next!.title}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EpgScheduleBottomSheet(
        channelId: widget.channelId,
        channelName: widget.channelName,
      ),
    );
  }
}

