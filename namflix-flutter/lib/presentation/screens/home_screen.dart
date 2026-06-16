import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/channel/channel_bloc.dart';
import '../blocs/channel/channel_event.dart';
import '../blocs/channel/channel_state.dart';
import '../widgets/hero_channel_card.dart';
import '../widgets/horizontal_channel_row.dart';
import '../widgets/shimmer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ChannelBloc>().add(const LoadChannels(sort: 'trending', liveOnly: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'NamFlix',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accentRed,
        backgroundColor: AppColors.surface,
        onRefresh: () async => context.read<ChannelBloc>().add(const RefreshChannels()),
        child: BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            if (state is ChannelLoading) {
              return ListView(
                children: const [
                  SizedBox(height: 16),
                  ShimmerCard(height: 180, width: double.infinity),
                  ShimmerChannelGrid(count: 8),
                ],
              );
            }

            if (state is ChannelError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: AppColors.textMuted, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ChannelBloc>().add(const RefreshChannels()),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
                      child: const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            if (state is ChannelLoaded) {
              final channels = state.channels;
              final hero = channels.isNotEmpty ? channels.first : null;
              final trending = channels.take(10).toList();
              final liveNow = channels.where((c) => c.isLive).toList();

              return ListView(
                children: [
                  if (hero != null)
                    HeroChannelCard(channel: hero),
                  HorizontalChannelRow(
                    title: 'Trending Now',
                    channels: trending,
                    onSeeAll: () => context.push('/live'),
                  ),
                  if (liveNow.isNotEmpty)
                    HorizontalChannelRow(
                      title: 'Live Now',
                      channels: liveNow,
                      onSeeAll: () => context.push('/live'),
                    ),
                  const SizedBox(height: 24),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomIndex,
        onDestinationSelected: (i) {
          setState(() => _bottomIndex = i);
          switch (i) {
            case 1: context.push('/live'); break;
            case 2: context.push('/search'); break;
            case 3: context.push('/favorites'); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.live_tv_outlined), selectedIcon: Icon(Icons.live_tv_rounded), label: 'Live'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search_rounded), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite_rounded), label: 'Favorites'),
        ],
      ),
    );
  }
}
