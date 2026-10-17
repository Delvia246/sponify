import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../widgets/like_button.dart';
import '../widgets/song_options_sheet.dart';
import '../widgets/sponify_code_sheet.dart';
import '../widgets/profile_menu_sheet.dart';
import '../widgets/song_artwork.dart'; // IMPORT BARU
import 'music_screen.dart';
import 'podcast_screen.dart';

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
      _results = _allSongs
          .where(
            (song) =>
                song.title.toLowerCase().contains(lower) ||
                song.artist.toLowerCase().contains(lower) ||
                song.album.toLowerCase().contains(lower),
          )
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearch('');
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1DB954)),
              )
            : _isSearching
            ? _buildSearchResults()
            : _buildBrowse(),
      ),
    );
  }

  Widget _buildBrowse() {
    return CustomScrollView(
      slivers: [
        // === HEADER ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                // Avatar profil → buka ProfileMenuSheet
                GestureDetector(
                  onTap: () => ProfileMenuSheet.show(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cari',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Icon kamera
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () => SponifyCodeSheet.show(context),
                ),
              ],
            ),
          ),
        ),

        // === SEARCH BAR ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Apa yang ingin kamu dengar?',
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 24,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // === GRID KATEGORI ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: [
                _categoryCard(
                  'Musik',
                  const Color(0xFFE91E63),
                  Icons.music_note,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MusicScreen(),
                      ),
                    );
                  },
                ),
                _categoryCard(
                  'Podcast',
                  const Color(0xFF00695C),
                  Icons.podcasts,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PodcastScreen(),
                      ),
                    );
                  },
                ),
                _categoryCard(
                  'Acara Langsung',
                  const Color(0xFF7B1FA2),
                  Icons.mic,
                  () => _quickSnack(context, 'Acara Langsung segera hadir'),
                ),
                _categoryCard(
                  'K-Pop ON!',
                  const Color(0xFF3949AB),
                  Icons.star,
                  () => _quickSnack(context, 'K-Pop ON! segera hadir'),
                ),
                _categoryCard(
                  'Dibuat Untuk Kamu',
                  const Color(0xFF7E57C2),
                  Icons.person,
                  () => _quickSnack(context, 'Dibuat Untuk Kamu segera hadir'),
                ),
                _categoryCard(
                  'Baru Rilis',
                  const Color(0xFF1DB954),
                  Icons.new_releases,
                  () => _quickSnack(context, 'Baru Rilis segera hadir'),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // === SECTION ===
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Temukan sesuatu yang lain',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // === HORIZONTAL CARD ===
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none, // FIX: agar tidak terpotong
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _discoverCard('#secret admirer', const Color(0xFF37474F)),
                _discoverCard('#downtown vibes', const Color(0xFF4A3B32)),
                _discoverCard('#demo', const Color(0xFF1F3A2E)),
                _discoverCard('#chill vibes', const Color(0xFF2C3E50)),
                _discoverCard('#coding', const Color(0xFF3D2C4D)),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  void _quickSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  Widget _categoryCard(
    String title,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -8,
              right: -8,
              child: Transform.rotate(
                angle: 0.4,
                child: Icon(
                  icon,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 64,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _discoverCard(String hashtag, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color, color.withValues(alpha: 0.3)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Icon(
              Icons.music_note,
              color: Colors.white.withValues(alpha: 0.3),
              size: 28,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              hashtag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // === HASIL PENCARIAN ===
  Widget _buildSearchResults() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearch,
            autofocus: true,
            style: const TextStyle(color: Colors.black, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Apa yang ingin kamu dengar?',
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 24,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: _clearSearch,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: _results.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada hasil ditemukan',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final song = _results[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      leading: SongArtwork(
                        // GANTI: SongArtwork
                        imageUrl: song.coverUrl,
                        size: 52,
                        borderRadius: 4,
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
                    );
                  },
                ),
        ),
      ],
    );
  }
}
