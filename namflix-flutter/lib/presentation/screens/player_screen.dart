import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/tv_stream.dart';
import '../../domain/repositories/channel_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../blocs/player/player_bloc.dart';
import '../blocs/player/player_event.dart';
import '../blocs/player/player_state.dart';
import '../widgets/live_badge.dart';

class PlayerScreen extends StatelessWidget {
  final String channelId;

  const PlayerScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => PlayerBloc(
        ctx.read<ChannelRepository>(),
        ctx.read<UserRepository>(),
      )..add(LoadStreams(channelId)),
      child: const _PlayerView(),
    );
  }
}

class _PlayerView extends StatefulWidget {
  const _PlayerView();

  @override
  State<_PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<_PlayerView> {
  BetterPlayerController? _playerController;
  bool _isFullscreen = false;

  @override
  void dispose() {
    _playerController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _initPlayer(TvStream stream) {
    _playerController?.dispose();

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      stream.url,
      headers: stream.headers,
      liveStream: true,
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 3000,
        maxBufferMs: 8000,
        bufferForPlaybackMs: 1500,
        bufferForPlaybackAfterRebufferMs: 3000,
      ),
    );

    _playerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.black54,
          iconsColor: Colors.white,
          progressBarPlayedColor: AppColors.accentRed,
          progressBarHandleColor: AppColors.accentRed,
          progressBarBufferedColor: Colors.white38,
          progressBarBackgroundColor: Colors.white12,
          enableFullscreen: true,
          enablePlayPause: true,
          enableMute: true,
          enableSkips: false,
          enableOverflowMenu: true,
        ),
        eventListener: (event) {
          if (event.betterPlayerEventType == BetterPlayerEventType.changedPlayerVisibility) {
            setState(() => _isFullscreen = _playerController?.isFullScreen ?? false);
          }
        },
      ),
      betterPlayerDataSource: dataSource,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state is PlayerReady) {
          _initPlayer(state.activeStream);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: _isFullscreen,
          appBar: _isFullscreen
              ? null
              : AppBar(
                  backgroundColor: Colors.black,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  title: state is PlayerReady
                      ? Row(
                          children: [
                            Text(
                              state.channel.name,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            if (state.channel.isLive) const LiveBadge(),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
          body: Column(
            children: [
              // Video player
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildPlayer(state),
              ),
              if (!_isFullscreen && state is PlayerReady) ...[
                // Quality selector
                if (state.streams.length > 1)
                  Container(
                    height: 48,
                    color: AppColors.background,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      children: state.streams.map((stream) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            context.read<PlayerBloc>().add(SelectQuality(stream));
                            _initPlayer(stream);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: state.activeStream.id == stream.id
                                  ? AppColors.accentRed
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              stream.quality?.toUpperCase() ?? 'AUTO',
                              style: TextStyle(
                                color: state.activeStream.id == stream.id
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayer(PlayerState state) {
    if (state is PlayerLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.accentRed, strokeWidth: 2),
            SizedBox(height: 12),
            Text('Loading stream...', style: TextStyle(color: Colors.white60, fontSize: 13)),
          ],
        ),
      );
    }

    if (state is PlayerError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white38, size: 44),
            const SizedBox(height: 12),
            Text(state.message, style: const TextStyle(color: Colors.white60, fontSize: 13), textAlign: TextAlign.center),
          ],
        ),
      );
    }

    if (_playerController != null) {
      return BetterPlayer(controller: _playerController!);
    }

    return const SizedBox.shrink();
  }
}
