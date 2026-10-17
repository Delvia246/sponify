import 'package:flutter/material.dart';

import '../services/player_service.dart';
import '../screens/full_player_screen.dart';
import 'song_artwork.dart';

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
              MaterialPageRoute(builder: (context) => const FullPlayerScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8), // Mengambang
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3E3E3E), // Warna abu-abu gelap sesuai SS
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SongArtwork(imageUrl: song.coverUrl, size: 48, borderRadius: 4),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF1DB954),
                  ),
                  onPressed: () {}, // Like button
                ),
                IconButton(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => playerService.togglePlayPause(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
