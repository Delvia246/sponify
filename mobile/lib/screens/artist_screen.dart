import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../widgets/song_artwork.dart';

class ArtistScreen extends StatefulWidget {
  final int artistId;
  final String artistName;

  const ArtistScreen({
    super.key,
    required this.artistId,
    required this.artistName,
  });

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
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
      _songs = allSongs.where((s) => s.artistId == widget.artistId).toList();
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
                    expandedHeight: 300,
                    backgroundColor: const Color(0xFF4A148C),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SongArtwork(
                            imageUrl: _songs.isNotEmpty
                                ? _songs.first.coverUrl
                                : '',
                            size: 150,
                            isCircle: true,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.artistName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified,
                                color: Color(0xFF1DB954),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Diverifikasi oleh Sponify',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Populer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                            '${song.album} • ${song.formattedDuration}',
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
