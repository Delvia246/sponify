import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/player_service.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

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

                const SizedBox(height: 40),

                // ===== JUDUL & ARTIS + LIKE =====
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
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.white, size: 26),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Fitur like segera hadir')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

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

                const SizedBox(height: 16),

                // ===== KONTROL UTAMA =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.shuffle, color: Colors.white),
                        onPressed: () {},
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
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.repeat, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}