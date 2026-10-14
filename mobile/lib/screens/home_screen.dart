import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/song.dart';
import '../services/song_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);
    final songs = await SongService().getAllSongs();
    setState(() {
      _songs = songs;
      _filteredSongs = songs;
      _isLoading = false;
    });
  }

  void _filterSongs(String query) {
    if (query.isEmpty) {
      setState(() => _filteredSongs = _songs);
    } else {
      final lower = query.toLowerCase();
      setState(() {
        _filteredSongs = _songs.where((song) =>
          song.title.toLowerCase().contains(lower) ||
          song.artist.toLowerCase().contains(lower)
        ).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: sapaan + logout
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Selamat datang di Sponify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSongs,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari lagu atau artis...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF282828),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Judul section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Daftar Lagu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // List lagu
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DB954),
                      ),
                    )
                  : _filteredSongs.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada lagu',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _filteredSongs.length,
                          itemBuilder: (context, index) {
                            final song = _filteredSongs[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: song.coverUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 56,
                                    height: 56,
                                    color: const Color(0xFF282828),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 56,
                                    height: 56,
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
                                '${song.artist} • ${song.album}',
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                song.formattedDuration,
                                style: const TextStyle(color: Colors.grey),
                              ),
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