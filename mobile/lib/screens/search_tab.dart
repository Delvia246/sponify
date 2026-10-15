import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../widgets/like_button.dart';
import '../widgets/song_options_sheet.dart';
import '../widgets/sponify_code_sheet.dart';

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

  void _onCategoryTap(String categoryName) {
    _searchController.text = categoryName;
    _onSearch(categoryName);
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

  // ============================================
  // VIEW 1: BROWSE
  // ============================================
  Widget _buildBrowse() {
    return CustomScrollView(
      slivers: [
        // === HEADER: Profile + "Cari" + Kamera ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                // Avatar profil
                Container(
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
                const SizedBox(width: 12),

                // Judul "Cari"
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
                  onPressed: () {
                    SponifyCodeSheet.show(context);
                  },
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
                  () => _onCategoryTap('Musik'),
                ),
                _categoryCard(
                  'Podcast',
                  const Color(0xFF00695C),
                  Icons.podcasts,
                  () => _onCategoryTap('Podcast'),
                ),
                _categoryCard(
                  'Acara Langsung',
                  const Color(0xFF7B1FA2),
                  Icons.mic,
                  () => _onCategoryTap('Acara'),
                ),
                _categoryCard(
                  'K-Pop ON!',
                  const Color(0xFF3949AB),
                  Icons.star,
                  () => _onCategoryTap('K-Pop'),
                ),
                _categoryCard(
                  'Dibuat Untuk Kamu',
                  const Color(0xFF7E57C2),
                  Icons.person,
                  () => _onCategoryTap('Daily Mix'),
                ),
                _categoryCard(
                  'Baru Rilis',
                  const Color(0xFF1DB954),
                  Icons.new_releases,
                  () => _onCategoryTap('New'),
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

  // ============================================
  // VIEW 2: HASIL PENCARIAN
  // ============================================
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
                    );
                  },
                ),
        ),
      ],
    );
  }
}
