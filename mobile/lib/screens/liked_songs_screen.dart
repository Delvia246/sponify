import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';
import '../services/liked_service.dart';
import '../services/player_service.dart';
import '../services/session_service.dart';

class LikedSongsScreen extends StatefulWidget {
  const LikedSongsScreen({super.key});

  @override
  State<LikedSongsScreen> createState() => _LikedSongsScreenState();
}

class _LikedSongsScreenState extends State<LikedSongsScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLiked();
  }

  Future<void> _loadLiked() async {
    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;

    final songs = await LikedService().getLikedSongs(userId);
    if (!mounted) return;
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _playSong(int index) async {
    await PlayerService().playPlaylist(_songs, index);
  }

  Future<void> _playAll() async {
    if (_songs.isEmpty) return;
    await PlayerService().playPlaylist(_songs, 0);
  }

  Future<void> _unlike(int index) async {
    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;

    final result = await LikedService().toggleLike(userId, _songs[index].id);
    if (!mounted) return;

    // FIX: hapus `result != null` — result sudah pasti bool (non-null)
    if (result == false) {
      setState(() => _songs.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lagu dihapus dari Liked Songs')),
      );
    }
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
                    expandedHeight: 280,
                    backgroundColor: const Color(0xFF4B22F4),
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
                            colors: [Color(0xFF4B22F4), Color(0xFF121212)],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7B5CFF),
                                    Color(0xFF4B22F4),
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
                                Icons.favorite,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Liked Songs',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_songs.length} lagu',
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

                  // === TOMBOL PLAY ALL + SHUFFLE ===
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
                        ],
                      ),
                    ),
                  ),

                  // === LIST LAGU ===
                  _songs.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'Belum ada lagu yang disukai.\nTekan ikon hati di player untuk like lagu.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final song = _songs[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    song.formattedDuration,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Color(0xFF1DB954),
                                    ),
                                    onPressed: () => _unlike(index),
                                  ),
                                ],
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
