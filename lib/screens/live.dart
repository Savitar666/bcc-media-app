import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bccm_player/bccm_player.dart';
import 'package:bccm_player/cast_button.dart';
import 'package:bccm_player/playback_platform_pigeon.g.dart';
import 'package:bccm_player/playback_service_interface.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brunstadtv_app/api/livestream.dart';
import 'package:brunstadtv_app/components/mini_player.dart';
import 'package:brunstadtv_app/providers/playback_api.dart';
import 'package:brunstadtv_app/providers/video_state.dart';

import '../helpers/btv_colors.dart';
import '../helpers/btv_typography.dart';
import '../providers/chromecast.dart';
import '../services/auth_service.dart';
import 'calendar/calendar.dart';

class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen> with AutoRouteAware {
  String name = AuthService.instance.user!.name!;
  final TextEditingController _idTokenDisplayController =
      TextEditingController(text: AuthService.instance.idToken);
  Future? playerFuture;
  LivestreamUrl? liveUrl;
  bool audioOnly = false;
  bool settingUp = false;
  String? error;
  Timer? refreshTimer;
  Completer? setupCompleter;

  @override
  void initState() {
    super.initState();
    print('initState');
    final tabsRouter = context.tabsRouter;
    tabsRouter.addListener(() {
      if (tabsRouter.activeIndex == 2) {}
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future setup() async {
    // TODO: move to some playbackservice
    setState(() {
      error = null;
      settingUp = true;
    });
    await () async {
      var castingNow = ref.read(isCasting);
      var player = castingNow
          ? ref.read(castPlayerProvider)
          : ref.read(primaryPlayerProvider);

      if (player == null) {
        throw ErrorDescription('player cant be null');
      }

      var playbackApi = ref.read(playbackApiProvider);
      var liveUrl = await fetchLiveUrl();

      if (!mounted) return;

      setState(() {
        this.liveUrl = liveUrl;
      });

      await playbackApi.replaceCurrentMediaItem(
          player.playerId,
          autoplay: true,
          MediaItem(
              url: liveUrl.streamUrl,
              mimeType: 'application/x-mpegURL',
              isLive: true,
              metadata: MediaMetadata(
                  artist: 'BrunstadTV',
                  title: 'Live',
                  extras: {'id': 'livestream'},
                  artworkUri:
                      'https://brunstad.tv/static/images/poster_placeholder.jpg')));

      if (!mounted) return;

      ensurePlayingWithinReasonableTime(
          castingNow ? castPlayerProvider : primaryPlayerProvider);

      scheduleRefreshBasedOn(liveUrl.expiryTime);
    }();
  }

  void scheduleRefreshBasedOn(DateTime expiryTime) {
    final durationUntilExpiry = expiryTime.difference(DateTime.now());
    // Example: if expiry is in 180minutes, we refresh after 162 minutes
    final durationUntilRefresh =
        durationUntilExpiry - (durationUntilExpiry * 0.1);
    refreshTimer = Timer(durationUntilRefresh, () => setup());
  }

  void setStateIfMounted(void Function() fn) {
    if (!mounted) {
      return;
    }
    setState(fn);
  }

  Future ensurePlayingWithinReasonableTime(
      StateNotifierProvider<PlayerNotifier, Player?> playerProvider) async {
    setStateIfMounted(() {
      setupCompleter = Completer();
    });

    () async {
      while (true) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        debugPrint('bccm: setupCompleter watch loop ${DateTime.now()}');
        if (isCorrectItem(ref.read(playerProvider)?.currentMediaItem)) {
          debugPrint('bccm: isCorrectItem ${DateTime.now()} !!!!!!!!!!!!!!!!!');
          setupCompleter?.complete();
          setStateIfMounted(() {
            error = null;
            settingUp = false;
          });
          return;
        }
      }
    }();

    await setupCompleter?.future.timeout(const Duration(milliseconds: 10000),
        onTimeout: () {
      debugPrint("bccm: TIMEOUT ${DateTime.now()}");
      setStateIfMounted(() {
        error = 'Something might have gone wrong (timeout).';
      });
    }).catchError((err) {
      error = 'Something went wrong. Technical details: $err.';
    });
  }

  bool isCorrectItem(MediaItem? mediaItem) {
    return mediaItem?.metadata?.extras?['id'] == 'livestream';
  }

  @override
  Widget build(BuildContext context) {
    final casting = ref.watch(isCasting);
    var playerProvider = casting ? castPlayerProvider : primaryPlayerProvider;
    var player = ref.watch(playerProvider);

    if (player == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(30.0 + MediaQuery.of(context).padding.top),
          child: SafeArea(
            child: Stack(children: [
              const Center(child: Text('Live')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          audioOnly = !audioOnly;
                        }),
                        child: const Text('Audio only'),
                      )),
                  const SizedBox(width: 40, child: CastButton()),
                ],
              ),
            ]),
          )),
      body: SingleChildScrollView(
        primary: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          if (audioOnly)
            const MiniPlayer()
          else if (player.currentMediaItem?.metadata?.extras?['id'] !=
              'livestream')
            _playPoster(player)
          else
            _player(player),
          _info()
          //
        ]),
      ),
    );
  }

  Widget _info() {
    const episodeInfo = null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (episodeInfo != null)
          Container(
            color: BtvColors.background2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Episode title', style: BtvTextStyles.title2),
                    ],
                  ),
                )
              ],
            ),
          ),
        const CalendarWidget(collapsed: true)
      ],
    );
  }

  Widget _player(Player player) {
    return BccmPlayer(id: player.playerId);
  }

  Widget _playPoster(Player player) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          //excludeFromSemantics: true,
          onTap: () {
            setState(() {
              setup();
            });
          },
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ExtendedImage.network(
                  'https://brunstad.tv/static/images/placeholder.jpg',
                  fit: BoxFit.fill,
                  width: 64,
                  height: 36,
                ),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (error != null && !isCorrectItem(player.currentMediaItem))
                Text(error ?? ''),
              Center(
                  child: !settingUp
                      ? Image.asset(
                          'assets/icons/Play.png',
                          gaplessPlayback: true,
                        )
                      : const CircularProgressIndicator())
            ],
          ),
        ),
      ],
    );
  }
}
