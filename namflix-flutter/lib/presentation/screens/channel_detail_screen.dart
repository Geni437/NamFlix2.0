import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/repositories/channel_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/favorites/favorites_state.dart';
import '../blocs/player/player_bloc.dart';
import '../blocs/player/player_event.dart';
import '../blocs/player/player_state.dart';
import '../widgets/live_badge.dart';

class ChannelDetailScreen extends StatelessWidget {
  final String channelId;

  const ChannelDetailScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => PlayerBloc(
        ctx.read<ChannelRepository>(),
        ctx.read<UserRepository>(),
      )..add(LoadStreams(channelId)),
      child: const _ChannelDetailView(),
    );
  }
}

class _ChannelDetailView extends StatelessWidget {
  const _ChannelDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, playerState) {
              if (playerState is! PlayerReady) return const SizedBox.shrink();
              return BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favState) {
                  final isFav = favState is FavoritesLoaded && favState.isFavorite(playerState.channel.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? AppColors.accentRed : AppColors.textSecondary,
                    ),
                    onPressed: () => context.read<FavoritesBloc>().add(
                      ToggleFavorite(playerState.channel.id, currentlyFavorited: isFav),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentRed));
          }

          if (state is PlayerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.textMuted, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.surface),
                    child: const Text('Go Back', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ],
              ),
            );
          }

          if (state is PlayerReady) {
            final channel = state.channel;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: channel.logoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Image.network(
                                    channel.logoUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.tv, color: AppColors.textMuted),
                                  ),
                                ),
                              )
                            : const Icon(Icons.tv, color: AppColors.textMuted, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    channel.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (channel.isLive) ...[
                                  const SizedBox(width: 8),
                                  const LiveBadge(),
                                ],
                              ],
                            ),
                            if (channel.country != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(channel.country!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                              ),
                            if (channel.categories.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Wrap(
                                  spacing: 6,
                                  children: channel.categories.take(3).map((cat) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceElevated,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(cat, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                  )).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Play button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/player/${channel.id}'),
                      icon: const Icon(Icons.play_arrow_rounded, size: 22, color: Colors.white),
                      label: const Text('Watch Live', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stream quality selector
                  if (state.streams.length > 1) ...[
                    const Text('Quality', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: state.streams.map((stream) => ChoiceChip(
                        label: Text(stream.quality?.toUpperCase() ?? 'AUTO'),
                        selected: state.activeStream.id == stream.id,
                        onSelected: (_) => context.read<PlayerBloc>().add(SelectQuality(stream)),
                        selectedColor: AppColors.accentBlue,
                        labelStyle: TextStyle(
                          color: state.activeStream.id == stream.id ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        backgroundColor: AppColors.surfaceElevated,
                        side: BorderSide.none,
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Report button
                  TextButton.icon(
                    onPressed: () => _showReportDialog(context, state.activeStream.id),
                    icon: const Icon(Icons.flag_outlined, size: 14, color: AppColors.textMuted),
                    label: const Text('Report stream issue', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showReportDialog(BuildContext context, String streamId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Report Stream', style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ReportOption(streamId: streamId, reason: 'not_working', label: 'Stream not working'),
            _ReportOption(streamId: streamId, reason: 'poor_quality', label: 'Poor video quality'),
            _ReportOption(streamId: streamId, reason: 'geo_blocked', label: 'Geo-blocked in my region'),
            _ReportOption(streamId: streamId, reason: 'wrong_content', label: 'Wrong channel content'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
        ],
      ),
    );
  }
}

class _ReportOption extends StatelessWidget {
  final String streamId;
  final String reason;
  final String label;

  const _ReportOption({required this.streamId, required this.reason, required this.label});

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
    contentPadding: EdgeInsets.zero,
    onTap: () {
      context.read<PlayerBloc>().add(ReportStream(streamId, reason));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted. Thank you.'), backgroundColor: AppColors.accentBlue),
      );
    },
  );
}
