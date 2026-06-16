import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/channel.dart';
import 'channel_card.dart';

class HorizontalChannelRow extends StatelessWidget {
  final String title;
  final List<Channel> channels;
  final VoidCallback? onSeeAll;

  const HorizontalChannelRow({
    super.key,
    required this.title,
    required this.channels,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (channels.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors.accentBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: channels.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                width: 120,
                child: ChannelCard(
                  channel: channels[index],
                  compact: true,
                  onTap: () => context.push('/channel/${channels[index].id}'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
