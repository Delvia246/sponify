import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/player_service.dart';
import '../widgets/song_artwork.dart';
import '../widgets/now_playing_indicator.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerService = PlayerService();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ===
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Antrian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      playerService.clearQueue();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Antrian dibersihkan'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text(
                      'Kosongkan',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            // === BODY ===
            Expanded(
              child: AnimatedBuilder(
                animation: playerService,
                builder: (context, _) {
                  final currentSong = playerService.currentSong;
                  final playlist = playerService.playlist;
                  final currentIndex = playerService.currentIndex;

                  if (currentSong == null) {
                    return const Center(
                      child: Text(
                        'Tidak ada lagu yang diputar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // Lagu selanjutnya (setelah currentIndex)
                  final nextSongs = currentIndex + 1 < playlist.length
                      ? playlist.sublist(currentIndex + 1)
                      : <Song>[];

                  return CustomScrollView(
                    slivers: [
                      // === NOW PLAYING ===
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Text(
                            'Sedang Diputar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF282828),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SongArtwork(
                                    imageUrl: currentSong.coverUrl,
                                    size: 52,
                                    borderRadius: 6,
                                  ),
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Center(
                                      child: NowPlayingIndicator(),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                currentSong.title,
                                style: const TextStyle(
                                  color: Color(0xFF1DB954), // Hijau
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                currentSong.artist,
                                style: const TextStyle(
                                  color: Color(0xFF1DB954),
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // === NEXT UP ===
                      if (nextSongs.isNotEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Text(
                              'Berikutnya dari antrian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final song = nextSongs[index];
                            // Cek apakah lagu ini dari queue manual atau playlist asli
                            final isFromQueue = playerService.queue.contains(
                              song,
                            );

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 2,
                              ),
                              leading: SongArtwork(
                                imageUrl: song.coverUrl,
                                size: 52,
                                borderRadius: 4,
                              ),
                              title: Text(
                                song.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.artist,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: isFromQueue
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1DB954)
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Dari Antrian',
                                        style: TextStyle(
                                          color: Color(0xFF1DB954),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : null,
                              // Tap untuk memutar lagu ini (lompat ke index)
                              onTap: () {
                                playerService.playPlaylist(
                                  playlist,
                                  currentIndex + 1 + index,
                                );
                              },
                            );
                          }, childCount: nextSongs.length),
                        ),
                      ] else
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.queue_music,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Antrian kosong.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
