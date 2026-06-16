import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/country.dart';
import '../blocs/channel/channel_bloc.dart';
import '../blocs/channel/channel_event.dart';
import '../blocs/channel/channel_state.dart';
import '../widgets/channel_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/shimmer_card.dart';

class LiveScreen extends StatefulWidget {
  final String? initialCountry;
  final String? initialCategory;

  const LiveScreen({super.key, this.initialCountry, this.initialCategory});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  late FilterOptions _filters;
  final List<Category> _categories = [];
  final List<Country> _countries = [];
  final List<Country> _languages = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filters = FilterOptions(
      liveOnly: true,
      country: widget.initialCountry,
      categories: widget.initialCategory != null ? [widget.initialCategory!] : [],
    );
    _loadChannels();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadChannels() {
    context.read<ChannelBloc>().add(LoadChannels(
      liveOnly: _filters.liveOnly,
      country: _filters.country,
      language: _filters.language,
      categories: _filters.categories.isNotEmpty ? _filters.categories : null,
      sort: _filters.sort,
    ));
  }

  void _onScroll() {
    final state = context.read<ChannelBloc>().state;
    if (state is ChannelLoaded && state.hasMore &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<ChannelBloc>().add(const LoadMoreChannels());
    }
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        current: _filters,
        categories: _categories,
        countries: _countries,
        languages: _languages,
      ),
    );
    if (result != null) {
      setState(() => _filters = result);
      _loadChannels();
    }
  }

  bool get _hasActiveFilters =>
      _filters.country != null ||
      _filters.language != null ||
      _filters.categories.isNotEmpty ||
      !_filters.liveOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: const Text('Live TV', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: AppColors.textSecondary),
                onPressed: _openFilters,
              ),
              if (_hasActiveFilters)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(color: AppColors.accentRed, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ChannelBloc, ChannelState>(
        builder: (context, state) {
          if (state is ChannelLoading) return const ShimmerChannelGrid();

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
                    onPressed: _loadChannels,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          List<dynamic> channels = [];
          bool loadingMore = false;

          if (state is ChannelLoaded) {
            channels = state.channels;
          } else if (state is ChannelLoadingMore) {
            channels = state.currentChannels;
            loadingMore = true;
          }

          if (channels.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.live_tv_rounded, color: AppColors.textMuted, size: 48),
                  SizedBox(height: 12),
                  Text('No channels found', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.95,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: channels.length + (loadingMore ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= channels.length) return const ShimmerCard(height: double.infinity);
              return ChannelCard(channel: channels[index]);
            },
          );
        },
      ),
    );
  }
}
