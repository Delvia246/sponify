import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/player_service.dart';
import '../services/liked_service.dart';
import '../services/session_service.dart';
import '../widgets/music_visualizer.dart';
import 'lyrics_screen.dart';

class FullPlayerScreen extends StatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  bool _isLiked = false;
  int? _currentSongId;

  @override
  void initState() {
    super.initState();
    _checkLiked();
    PlayerService().addListener(_onSongChanged);
  }

  @override
  void dispose() {
    PlayerService().removeListener(_onSongChanged);
    super.dispose();
  }

  void _onSongChanged() {
    final song = PlayerService().currentSong;
    if (song != null && song.id != _currentSongId) {
      _checkLiked();
    }
  }

  Future<void> _checkLiked() async {
    final song = PlayerService().currentSong;
    if (song == null) return;

    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;

    final liked = await LikedService().isLiked(userId, song.id);
    if (!mounted) return;
    setState(() {
      _isLiked = liked;
      _currentSongId = song.id;
    });
  }

  Future<void> _toggleLike() async {
    final song = PlayerService().currentSong;
    if (song == null) return;

    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;

    final result = await LikedService().toggleLike(userId, song.id);
    if (!mounted) return;

    if (result != null) {
      setState(() => _isLiked = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              result ? 'Ditambahkan ke Liked Songs' : 'Dihapus dari Liked Songs'),
          duration: const Duration(seconds: 1),
          backgroundColor:
              result ? const Color(0xFF1DB954) : const Color(0xFF282828),
        ),
      );
    }
  }

  // ============ FUNGSI SLEEP TIMER (BARU) ============
  void _showSleepTimerSheet(BuildContext context) {
    final playerService = PlayerService();
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Sleep Timer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              if (playerService.sleepTimerMinutes != null)
                ListTile(
                  leading: const Icon(Icons.timer_off, color: Colors.red),
                  title: const Text('Matikan Timer', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    playerService.cancelSleepTimer();
                    Navigator.pop(context);
                  },
                ),
              ...[5, 10, 15, 30, 45, 60].map((m) => ListTile(
                leading: const Icon(Icons.timer, color: Colors.white),
                title: Text('$m Menit', style: const TextStyle(color: Colors.white)),
                onTap: () {
                  playerService.startSleepTimer(m);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sleep Timer aktif: $m menit')),
                  );
                },
              )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  // ====================================================

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString();
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final playerService = PlayerService();

    return AnimatedBuilder(
      animation: playerService,
      builder: (context, _) {
        final song = playerService.currentSong;
        if (song == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(
              child: Text(
                'Tidak ada lagu yang diputar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SafeArea(
            child: Column(
              children: [
                // ===== TOP BAR =====
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Column(
                        children: [
                          Text(
                            'SEDANG DIPUTAR',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Playlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // ===== COVER BESAR =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: song.coverUrl,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(
                            color: const Color(0xFF282828),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.grey,
                              size: 80,
                            ),
                          ),
                          errorWidget: (c, u, e) => Container(
                            color: const Color(0xFF282828),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.grey,
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ===== MUSIC VISUALIZER =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: const MusicVisualizer(
                    barCount: 32,
                    height: 50,
                    color: Color(0xFF1DB954),
                  ),
                ),

                const SizedBox(height: 16),

                // ===== JUDUL & ARTIS + TIMER & LIKE =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                color: Color(0xFFB3B3B3),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // TOMBOL SLEEP TIMER (BARU)
                      IconButton(
                        iconSize: 28,
                        onPressed: () => _showSleepTimerSheet(context),
                        icon: Icon(
                          playerService.sleepTimerMinutes != null
                              ? Icons.hourglass_top
                              : Icons.hourglass_empty,
                          color: playerService.sleepTimerMinutes != null
                              ? const Color(0xFF1DB954)
                              : Colors.white,
                        ),
                      ),
                      // TOMBOL LIKE (ASLI)
                      IconButton(
                        iconSize: 30,
                        onPressed: _toggleLike,
                        icon: Icon(
                          _isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isLiked
                              ? const Color(0xFF1DB954)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ===== PROGRESS SLIDER =====
                StreamBuilder<Duration>(
                  stream: playerService.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration =
                        playerService.player.duration ?? Duration.zero;
                    final maxMs = duration.inMilliseconds.toDouble();
                    final posMs = position.inMilliseconds
                        .toDouble()
                        .clamp(0.0, maxMs);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: const Color(0xFF4D4D4D),
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14),
                              trackHeight: 3,
                            ),
                            child: Slider(
                              min: 0,
                              max: maxMs > 0 ? maxMs : 1,
                              value: maxMs > 0 ? posMs : 0,
                              onChanged: (value) {
                                playerService.seek(
                                    Duration(milliseconds: value.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // ===== KONTROL UTAMA =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TOMBOL SHUFFLE
                      IconButton(
                        iconSize: 28,
                        icon: Icon(
                          Icons.shuffle,
                          color: playerService.isShuffle
                              ? const Color(0xFF1DB954)
                              : Colors.white,
                        ),
                        onPressed: () => playerService.toggleShuffle(),
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.skip_previous,
                            color: Colors.white),
                        onPressed: () => playerService.previous(),
                      ),
                      Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          iconSize: 40,
                          icon: Icon(
                            playerService.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black,
                          ),
                          onPressed: () =>
                              playerService.togglePlayPause(),
                        ),
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.skip_next,
                            color: Colors.white),
                        onPressed: () => playerService.next(),
                      ),
                      // TOMBOL REPEAT
                      IconButton(
                        iconSize: 28,
                        icon: Icon(
                          playerService.repeatMode == 2
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: playerService.repeatMode > 0
                              ? const Color(0xFF1DB954)
                              : Colors.white,
                        ),
                        onPressed: () => playerService.cycleRepeatMode(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ===== TOMBOL LIRIK =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LyricsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lyrics_outlined,
                        color: Colors.white, size: 22),
                    label: const Text(
                      'Lirik',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      backgroundColor: const Color(0xFF282828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}