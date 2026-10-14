import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/song.dart';
import '../services/song_service.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _searchController = TextEditingController();
  List<Song> _allSongs = [];
  List<Song> _results = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final songs = await SongService().getAllSongs();
    if (!mounted) return;
    setState(() {
      _allSongs = songs;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _results = [];
      });
      return;
    }
    final lower = query.toLowerCase();
    setState(() {
      _isSearching = true;
      _results = _allSongs.where((song) =>
        song.title.toLowerCase().contains(lower) ||
        song.artist.toLowerCase().contains(lower) ||
        song.album.toLowerCase().contains(lower)
      ).toList();
    });
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
            // Judul halaman
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Cari',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Apa yang ingin kamu putar?',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Body
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF1DB954)),
                    )
                  : _isSearching
                      ? _buildResults()
                      : _buildCategories(),
            ),
          ],
        ),
      ),
    );
  }

  // Hasil pencarian
  Widget _buildResults() {
    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada hasil ditemukan',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final song = _results[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                child:
                    const Icon(Icons.music_note, color: Colors.grey),
              ),
              errorWidget: (c, u, e) => Container(
                width: 52,
                height: 52,
                color: const Color(0xFF282828),
                child:
                    const Icon(Icons.music_note, color: Colors.grey),
              ),
            ),
          ),
          title: Text(
            song.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            song.formattedDuration,
            style: const TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  // Kategori warna-warni (tampilan awal sebelum cari)
  Widget _buildCategories() {
    final categories = [
      {'name': 'Pop', 'color': const Color(0xFFE91E63)},
      {'name': 'Rock', 'color': const Color(0xFF9C27B0)},
      {'name': 'Hip-Hop', 'color': const Color(0xFFFF5722)},
      {'name': 'Jazz', 'color': const Color(0xFF3F51B5)},
      {'name': 'EDM', 'color': const Color(0xFF00BCD4)},
      {'name': 'Chill', 'color': const Color(0xFF4CAF50)},
      {'name': 'Lo-Fi', 'color': const Color(0xFF795548)},
      {'name': 'K-Pop', 'color': const Color(0xFFFF9800)},
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Container(
          decoration: BoxDecoration(
            color: cat['color'] as Color,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              cat['name'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}