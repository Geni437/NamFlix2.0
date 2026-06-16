import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/epg_program.dart';

class EpgCard extends StatelessWidget {
  final EpgProgram program;
  final bool isCurrentProgram;

  const EpgCard({super.key, required this.program, this.isCurrentProgram = false});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentProgram ? AppColors.accentBlue.withOpacity(0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentProgram ? AppColors.accentBlue.withOpacity(0.4) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${timeFormat.format(program.startTime)} – ${timeFormat.format(program.endTime)}',
                style: TextStyle(
                  color: isCurrentProgram ? AppColors.accentBlue : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isCurrentProgram) ...[
                const SizedBox(width: 8),
                Container(
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
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            program.title,
            style: TextStyle(
              color: isCurrentProgram ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isCurrentProgram ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (isCurrentProgram && program.progressPercent > 0) ...[
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
    );
  }
}
