import 'package:flutter/material.dart';

import '../services/player_service.dart';
import 'song_artwork.dart';
import 'sleep_timer_sheet.dart';

class QueueSheet extends StatelessWidget {
  const QueueSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const QueueSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerService = PlayerService();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // 80% tinggi layar
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: playerService,
          builder: (context, _) {
            final currentSong = playerService.currentSong;
            final playlist = playerService.playlist;
            final currentIndex = playerService.currentIndex;
            final nextSongs = currentIndex + 1 < playlist.length
                ? playlist.sublist(currentIndex + 1)
                : [];

            if (currentSong == null) return const SizedBox();

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Antrean',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Memutar Playlist',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Now Playing
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: SongArtwork(
                    imageUrl: currentSong.coverUrl,
                    size: 48,
                    borderRadius: 4,
                  ),
                  title: Text(
                    currentSong.title,
                    style: const TextStyle(
                      color: Color(0xFF1DB954),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    currentSong.artist,
                    style: const TextStyle(
                      color: Color(0xFF1DB954),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () => playerService.togglePlayPause(),
                  ),
                ),

                const Divider(color: Color(0xFF3E3E3E)),

                // Shuffling info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shuffle, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Shuffling dari:',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Next list
                Expanded(
                  child: nextSongs.isEmpty
                      ? const Center(
                          child: Text(
                            'Antrean kosong',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: nextSongs.length,
                          itemBuilder: (context, index) {
                            final song = nextSongs[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              leading: SongArtwork(
                                imageUrl: song.coverUrl,
                                size: 48,
                                borderRadius: 4,
                              ),
                              title: Text(
                                song.title,
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.artist,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(
                                Icons.drag_handle,
                                color: Colors.grey,
                              ),
                              onTap: () => playerService.playPlaylist(
                                playlist,
                                currentIndex + 1 + index,
                              ),
                            );
                          },
                        ),
                ),

                // Bottom Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            playerService.toggleShuffle();
                          },
                          icon: const Icon(
                            Icons.shuffle,
                            color: Color(0xFF1DB954),
                          ),
                          label: const Text(
                            'Shuffle',
                            style: TextStyle(color: Color(0xFF1DB954)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF282828),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Buka sleep timer dari dalam queue
                            SleepTimerSheet.show(context);
                          },
                          icon: const Icon(
                            Icons.timer_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Pengatur Waktu',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF282828),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
