import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../widgets/like_button.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;
  int _filterIndex = 0;
  final List<String> _filters = ['Semua', 'Musik', 'Podcast'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final songs = await SongService().getAllSongs();
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
                    'Musik',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _filterIndex == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterIndex = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF1DB954)
                              : const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            color: selected ? Colors.black : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // List lagu
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DB954),
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
                              Text(
                                song.formattedDuration,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _playSong(i),
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
