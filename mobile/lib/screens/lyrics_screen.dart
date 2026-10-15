import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/player_service.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

        // Pecah lirik per baris
        final lyricsLines = song.lyrics.isEmpty
            ? ['Lirik belum tersedia untuk lagu ini.']
            : song.lyrics.split('\n');

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
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        'LIRIK',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur share segera hadir'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ===== INFO LAGU =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: song.coverUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFF282828),
                            child: const Icon(Icons.music_note,
                                color: Colors.grey),
                          ),
                          errorWidget: (c, u, e) => Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFF282828),
                            child: const Icon(Icons.music_note,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                                fontSize: 13,
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

                // ===== LIRIK (auto-scroll) =====
                Expanded(
                  child: StreamBuilder<Duration>(
                    stream: playerService.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration =
                          playerService.player.duration ?? Duration.zero;
                      final progress = duration.inMilliseconds > 0
                          ? position.inMilliseconds /
                              duration.inMilliseconds
                          : 0.0;

                      // Baris yang lagi aktif (highlight)
                      final activeIndex =
                          (progress * lyricsLines.length).floor().clamp(
                                0,
                                lyricsLines.length - 1,
                              );

                      // Auto-scroll setelah frame render
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          const itemHeight = 44.0;
                          final targetOffset =
                              (activeIndex * itemHeight) -
                                  (MediaQuery.of(context).size.height / 3);
                          _scrollController.animateTo(
                            targetOffset.clamp(
                                0.0, _scrollController.position.maxScrollExtent),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        }
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 200),
                        itemCount: lyricsLines.length,
                        itemBuilder: (context, index) {
                          final line = lyricsLines[index];
                          final isActive = index == activeIndex;

                          return AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: isActive
                                  ? const Color(0xFF1DB954)
                                  : Colors.grey,
                              fontSize: isActive ? 22 : 20,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              height: 1.6,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              child: Text(line.isEmpty ? ' ' : line),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}