import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/library_service.dart';
import '../services/player_service.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await LibraryService().getPlaylistSongs(widget.playlistId);
    if (!mounted) return;
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _playAll() async {
    if (_songs.isEmpty) return;
    await PlayerService().playPlaylist(_songs, 0);
  }

  Future<void> _playSong(int index) async {
    await PlayerService().playPlaylist(_songs, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1DB954)),
              )
            : CustomScrollView(
                slivers: [
                  // === HEADER ===
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 320,
                    backgroundColor: const Color(0xFF1A3D2E),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF1A3D2E), Color(0xFF121212)],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.queue_music,
                                color: Colors.black,
                                size: 70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                widget.playlistName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Playlist • ${_songs.length} lagu',
                              style: const TextStyle(
                                color: Color(0xFFB3B3B3),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // === PLAY ALL + SHUFFLE ===
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _playAll,
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1DB954),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 34,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            iconSize: 32,
                            icon: const Icon(
                              Icons.shuffle,
                              color: Color(0xFF1DB954),
                            ),
                            onPressed: () {
                              if (_songs.isEmpty) return;
                              final shuffled = List<Song>.from(_songs)
                                ..shuffle();
                              PlayerService().playPlaylist(shuffled, 0);
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            iconSize: 28,
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  // === LIST LAGU ===
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final song = _songs[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: SizedBox(
                          width: 44,
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
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
                        trailing: Text(
                          song.formattedDuration,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => _playSong(index),
                      );
                    }, childCount: _songs.length),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }
}
