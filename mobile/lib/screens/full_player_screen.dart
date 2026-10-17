import 'package:flutter/material.dart';

import '../services/player_service.dart';
import '../services/liked_service.dart';
import '../services/session_service.dart';
import '../widgets/music_visualizer.dart';
import '../widgets/song_artwork.dart';
import '../widgets/queue_sheet.dart';
import '../widgets/sleep_timer_sheet.dart';
import '../widgets/share_sheet.dart';
import '../widgets/song_options_sheet.dart'; // IMPORT BARU
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
    final liked = await LikedService().isLiked(user?.id ?? 1, song.id);
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
    final result = await LikedService().toggleLike(user?.id ?? 1, song.id);
    if (!mounted) return;
    setState(() => _isLiked = result);
  }

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
          return const Scaffold(backgroundColor: Color(0xFF121212));
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Column(
                            children: [
                              Text(
                                'Memainkan dari Playlist',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
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
                          // FIX: Sambungkan titik 3 ke SongOptionsSheet
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              SongOptionsSheet.show(context, song);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cover
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
                          child: SongArtwork(
                            imageUrl: song.coverUrl,
                            size: MediaQuery.of(context).size.width - 64,
                            borderRadius: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Visualizer
                    const MusicVisualizer(
                      barCount: 32,
                      height: 40,
                      color: Color(0xFF1DB954),
                    ),

                    const SizedBox(height: 24),

                    // Title & Like
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
                          IconButton(
                            iconSize: 30,
                            onPressed: _toggleLike,
                            icon: Icon(
                              _isLiked
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: _isLiked
                                  ? const Color(0xFF1DB954)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Slider
                    StreamBuilder<Duration>(
                      stream: playerService.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration =
                            playerService.player.duration ?? Duration.zero;
                        final maxMs = duration.inMilliseconds.toDouble();
                        final posMs = position.inMilliseconds.toDouble().clamp(
                          0.0,
                          maxMs,
                        );

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
                                    enabledThumbRadius: 6,
                                  ),
                                  trackHeight: 3,
                                ),
                                child: Slider(
                                  min: 0,
                                  max: maxMs > 0 ? maxMs : 1,
                                  value: maxMs > 0 ? posMs : 0,
                                  onChanged: (value) => playerService.seek(
                                    Duration(milliseconds: value.toInt()),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(position),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(duration),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
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

                    // Controls
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                            ),
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
                              onPressed: () => playerService.togglePlayPause(),
                            ),
                          ),
                          IconButton(
                            iconSize: 40,
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                            ),
                            onPressed: () => playerService.next(),
                          ),
                          IconButton(
                            iconSize: 28,
                            icon: Icon(
                              Icons.timer_outlined,
                              color: playerService.isSleepTimerActive
                                  ? const Color(0xFF1DB954)
                                  : Colors.white,
                            ),
                            onPressed: () => SleepTimerSheet.show(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Row (Queue, Share)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.queue_music,
                              color: Colors.white,
                            ),
                            onPressed: () => QueueSheet.show(context),
                          ),
                          TextButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LyricsScreen(),
                              ),
                            ),
                            icon: const Icon(
                              Icons.lyrics_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'Lirik',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF282828),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => ShareSheet.show(context, song),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lirik Preview (Sederhana)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1E1E).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pratinjau lirik',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            song.lyrics.isNotEmpty
                                ? song.lyrics.split('\n')[0]
                                : 'Lirik belum tersedia...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            song.lyrics.split('\n').length > 1
                                ? song.lyrics.split('\n')[1]
                                : '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
