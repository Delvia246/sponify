import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../widgets/song_artwork.dart';

class AlbumScreen extends StatefulWidget {
  final int albumId;
  final String albumTitle;
  final String artistName;
  final String coverUrl;

  const AlbumScreen({
    super.key,
    required this.albumId,
    required this.albumTitle,
    required this.artistName,
    required this.coverUrl,
  });

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final allSongs = await SongService().getAllSongs();
    if (!mounted) return;
    setState(() {
      _songs = allSongs.where((s) => s.albumId == widget.albumId).toList();
      _isLoading = false;
    });
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
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 280,
                    backgroundColor: const Color(0xFF1A3D2E),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SongArtwork(
                            imageUrl: widget.coverUrl,
                            size: 150,
                            borderRadius: 8,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.albumTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.artistName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _songs.length,
                      itemBuilder: (context, i) {
                        final song = _songs[i];
                        return ListTile(
                          leading: Text(
                            '${i + 1}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          title: Text(
                            song.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            song.formattedDuration,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () => PlayerService().playPlaylist(_songs, i),
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
