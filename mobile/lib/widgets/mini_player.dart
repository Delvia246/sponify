import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/player_service.dart';
import '../screens/full_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playerService = PlayerService();

    return AnimatedBuilder(
      animation: playerService,
      builder: (context, _) {
        final song = playerService.currentSong;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FullPlayerScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Cover
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: song.coverUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(
                            width: 44,
                            height: 44,
                            color: const Color(0xFF1F1F1F),
                            child: const Icon(Icons.music_note,
                                color: Colors.grey, size: 20),
                          ),
                          errorWidget: (c, u, e) => Container(
                            width: 44,
                            height: 44,
                            color: const Color(0xFF1F1F1F),
                            child: const Icon(Icons.music_note,
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Judul + artist
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                color: Color(0xFFB3B3B3),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Tombol play/pause
                      IconButton(
                        iconSize: 32,
                        onPressed: () => playerService.togglePlayPause(),
                        icon: Icon(
                          playerService.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                      ),

                      // Tombol next
                      IconButton(
                        iconSize: 26,
                        onPressed: () => playerService.next(),
                        icon: const Icon(Icons.skip_next,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Progress bar tipis di bawah
                StreamBuilder<Duration>(
                  stream: playerService.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration =
                        playerService.player.duration ?? Duration.zero;
                    final progress = duration.inMilliseconds > 0
                        ? position.inMilliseconds / duration.inMilliseconds
                        : 0.0;
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 2,
                        backgroundColor: const Color(0xFF4D4D4D),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1DB954)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}