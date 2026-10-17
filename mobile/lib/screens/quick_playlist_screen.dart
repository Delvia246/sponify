import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/song.dart';
import '../services/player_service.dart';
import '../services/liked_service.dart';
import '../widgets/mini_player.dart';
import '../widgets/like_button.dart';
import '../widgets/now_playing_indicator.dart';
import '../widgets/song_options_sheet.dart';
import '../widgets/playlist_header.dart';
import '../widgets/playlist_options_sheet.dart';
import '../widgets/song_artwork.dart'; // IMPORT BARU

class QuickPlaylistScreen extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<Song> songs;
  final bool useLikedSongs;

  const QuickPlaylistScreen({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.songs,
    this.useLikedSongs = false,
  });

  @override
  State<QuickPlaylistScreen> createState() => _QuickPlaylistScreenState();
}

class _QuickPlaylistScreenState extends State<QuickPlaylistScreen> {
  List<Song> _songs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _songs = widget.songs;
    if (widget.useLikedSongs) {
      _loadLikedSongs();
    }
  }

  Future<void> _loadLikedSongs() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 1;
    final liked = await LikedService().getLikedSongs(userId);
    if (!mounted) return;
    setState(() {
      _songs = liked;
      _isLoading = false;
    });
  }

  Future<void> _playSong(int index) async {
    if (_songs.isEmpty) return;
    await PlayerService().playPlaylist(_songs, index);
  }

  void _shufflePlay() {
    if (_songs.isEmpty) return;
    final shuffled = List<Song>.from(_songs)..shuffle();
    PlayerService().playPlaylist(shuffled, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DB954),
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        // === HEADER ===
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              PlaylistHeader(
                                title: widget.title,
                                color: widget.color,
                                icon: widget.icon,
                                songs: _songs,
                                isLikedSongs: widget.useLikedSongs,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  4,
                                  20,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _playSong(0),
                                      child: Container(
                                        width: 52,
                                        height: 52,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF1DB954),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      iconSize: 28,
                                      icon: const Icon(
                                        Icons.shuffle,
                                        color: Color(0xFF1DB954),
                                      ),
                                      onPressed: _shufflePlay,
                                    ),
                                    IconButton(
                                      iconSize: 26,
                                      icon: const Icon(
                                        Icons.download_outlined,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Fitur download segera hadir',
                                                ),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                      },
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      iconSize: 26,
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        PlaylistOptionsSheet.show(
                                          context,
                                          playlistName: widget.title,
                                          songCount: _songs.length,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // === LIST LAGU ===
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            return _songTile(_songs[i], i);
                          }, childCount: _songs.length),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _songTile(Song song, int index) {
    return AnimatedBuilder(
      animation: PlayerService(),
      builder: (context, _) {
        final playerService = PlayerService();
        final isPlaying = playerService.currentSong?.id == song.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: SizedBox(
            width: 52,
            height: 52,
            child: isPlaying
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(child: NowPlayingIndicator()),
                  )
                : Hero(
                    tag: 'cover_${song.id}',
                    child: SongArtwork(
                      // GANTI: SongArtwork
                      imageUrl: song.coverUrl,
                      size: 52,
                      borderRadius: 4,
                    ),
                  ),
          ),
          title: Text(
            song.title,
            style: TextStyle(
              color: isPlaying ? const Color(0xFF1DB954) : Colors.white,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist,
            style: TextStyle(
              color: isPlaying ? const Color(0xFF1DB954) : Colors.grey,
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
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () {
                  SongOptionsSheet.show(context, song);
                },
              ),
            ],
          ),
          onTap: () => _playSong(index),
        );
      },
    );
  }
}
