import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/channel.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/favorites/favorites_state.dart';
import 'live_badge.dart';

class ChannelCard extends StatelessWidget {
  final Channel channel;
  final bool compact;
  final VoidCallback? onTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('/channel/${channel.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(compact ? 8 : 10),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          children: [
            // Logo area
            Expanded(
              flex: compact ? 3 : 4,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(compact ? 7 : 9),
                      ),
                    ),
                    child: channel.logoUrl != null
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.network(
                              channel.logoUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => _fallback(),
                            ),
                          )
                        : _fallback(),
                  ),
                  if (channel.isLive)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: LiveBadge(compact: compact),
                    ),
                  if (!compact)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, state) {
                          final isFav = state is FavoritesLoaded && state.isFavorite(channel.id);
                          return GestureDetector(
                            onTap: () => context.read<FavoritesBloc>().add(
                              ToggleFavorite(channel.id, currentlyFavorited: isFav),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.background.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? AppColors.accentRed : AppColors.textMuted,
                                size: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            // Name area
            Expanded(
              flex: compact ? 1 : 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 4 : 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      channel.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: compact ? 11 : 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!compact && channel.country != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        channel.country!,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() => const Center(child: Icon(Icons.tv, color: AppColors.textMuted, size: 28));
}
