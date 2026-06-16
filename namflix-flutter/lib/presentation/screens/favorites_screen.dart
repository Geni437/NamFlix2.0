import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/favorites/favorites_state.dart';
import '../widgets/channel_card.dart';
import '../widgets/shimmer_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is Authenticated) {
      context.read<FavoritesBloc>().add(const LoadFavorites());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: const Text('Favorites', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 48),
                  const SizedBox(height: 12),
                  const Text('Sign in to save your favorites', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/auth'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
                    child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.accentRed,
            backgroundColor: AppColors.surface,
            onRefresh: () async => context.read<FavoritesBloc>().add(const LoadFavorites()),
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoading) return const ShimmerChannelGrid();

                if (state is FavoritesError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: AppColors.textSecondary)));
                }

                if (state is FavoritesLoaded) {
                  if (state.channels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite_border_rounded, color: AppColors.textMuted, size: 56),
                          const SizedBox(height: 12),
                          const Text('No favorites yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                          const SizedBox(height: 6),
                          const Text('Tap ♡ on any channel to save it here',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => context.push('/live'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
                            child: const Text('Browse Channels', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: state.channels.length,
                    itemBuilder: (_, i) => ChannelCard(channel: state.channels[i]),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
