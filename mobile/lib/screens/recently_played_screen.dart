import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';
import '../services/history_service.dart';
import '../services/player_service.dart';
import '../widgets/mini_player.dart';
import '../widgets/like_button.dart';
import '../widgets/song_options_sheet.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final songs = await HistoryService.getAll();
    if (!mounted) return;
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _playSong(int index) async {
    if (_songs.isEmpty) return;
    await PlayerService().playPlaylist(_songs, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Baru Diputar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Filter chip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Musik',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DB954),
                      ),
                    )
                  : _songs.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada lagu yang diputar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _songs.length,
                      itemBuilder: (context, i) {
                        final song = _songs[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: song.coverUrl,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              placeholder: (c, u) => Container(
                                width: 52,
                                height: 52,
                                color: const Color(0xFF282828),
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (c, u, e) => Container(
                                width: 52,
                                height: 52,
                                color: const Color(0xFF282828),
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LikeButton(songId: song.id, size: 20),
                              const SizedBox(width: 4),
                              IconButton(
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  SongOptionsSheet.show(context, song);
                                },
                              ),
                            ],
                          ),
                          onTap: () => _playSong(i),
                        );
                      },
                    ),
            ),

            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
