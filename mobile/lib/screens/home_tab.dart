import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../widgets/phone_frame.dart';
import '../widgets/profile_menu_sheet.dart';
import 'quick_playlist_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Song> _songs = [];
  bool _isLoading = true;
  int _filterIndex = 0;
  final List<String> _filters = ['All', 'Music', 'Podcasts'];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await SongService().getAllSongs();
    if (!mounted) return;
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 17) return 'Selamat siang';
    if (hour < 20) return 'Selamat sore';
    return 'Selamat malam';
  }

  void _openProfile() {
    ProfileMenuSheet.show(context);
  }

  Future<void> _playSong(int index) async {
    if (_songs.isEmpty) return;
    final safeIndex = index % _songs.length;
    await PlayerService().playPlaylist(_songs, safeIndex);
  }

  void _openQuickPlaylist(String title, Color color, IconData icon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => phoneWrap(
          QuickPlaylistScreen(
            title: title,
            color: color,
            icon: icon,
            songs: _songs,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1DB954),
          onRefresh: _loadSongs,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1DB954)),
                )
              : CustomScrollView(
                  slivers: [
                    // === HEADER ===
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF1A3D2E), Color(0xFF121212)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Color(0xFF1DB954),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Sponify',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: _openProfile,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF1DB954),
                                          Color(0xFF1ED760),
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // === FILTER ===
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Row(
                          children: List.generate(_filters.length, (i) {
                            final selected = _filterIndex == i;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _filterIndex = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
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
                                      color: selected
                                          ? Colors.black
                                          : Colors.white,
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
                    ),

                    // === QUICK PICKS ===
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3.5,
                          children: [
                            _quickCard(
                              'Liked Songs',
                              const Color(0xFF4B22F4),
                              Icons.favorite,
                              () => _openQuickPlaylist(
                                'Liked Songs',
                                const Color(0xFF4B22F4),
                                Icons.favorite,
                              ),
                            ),
                            _quickCard(
                              'Daily Mix 1',
                              const Color(0xFFE91E63),
                              Icons.radio,
                              () => _openQuickPlaylist(
                                'Daily Mix 1',
                                const Color(0xFFE91E63),
                                Icons.radio,
                              ),
                            ),
                            _quickCard(
                              'Chill Vibes',
                              const Color(0xFF00BCD4),
                              Icons.nightlight_round,
                              () => _openQuickPlaylist(
                                'Chill Vibes',
                                const Color(0xFF00BCD4),
                                Icons.nightlight_round,
                              ),
                            ),
                            _quickCard(
                              'Trending',
                              const Color(0xFFFF5722),
                              Icons.trending_up,
                              () => _openQuickPlaylist(
                                'Trending',
                                const Color(0xFFFF5722),
                                Icons.trending_up,
                              ),
                            ),
                            _quickCard(
                              'Discover',
                              const Color(0xFF9C27B0),
                              Icons.explore,
                              () => _openQuickPlaylist(
                                'Discover',
                                const Color(0xFF9C27B0),
                                Icons.explore,
                              ),
                            ),
                            _quickCard(
                              'New Releases',
                              const Color(0xFF4CAF50),
                              Icons.new_releases,
                              () => _openQuickPlaylist(
                                'New Releases',
                                const Color(0xFF4CAF50),
                                Icons.new_releases,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // === YOUR TOP MIXES ===
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                            child: Text(
                              'Your top mixes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: _songs.length > 5 ? 5 : _songs.length,
                              itemBuilder: (context, i) {
                                final song = _songs[i];
                                return GestureDetector(
                                  onTap: () => _playSong(i),
                                  child: Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: 'cover_${song.id}',
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: song.coverUrl,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              placeholder: (c, u) => Container(
                                                width: 150,
                                                height: 150,
                                                color: const Color(0xFF282828),
                                              ),
                                              errorWidget: (c, u, e) =>
                                                  Container(
                                                    width: 150,
                                                    height: 150,
                                                    color: const Color(
                                                      0xFF282828,
                                                    ),
                                                    child: const Icon(
                                                      Icons.music_note,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          song.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          song.artist,
                                          style: const TextStyle(
                                            color: Color(0xFFB3B3B3),
                                            fontSize: 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // === RECOMMENDED ===
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                            child: Text(
                              'Recommended for you',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: _songs.length,
                              itemBuilder: (context, i) {
                                final song = _songs[i];
                                return GestureDetector(
                                  onTap: () => _playSong(i),
                                  child: Container(
                                    width: 130,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF282828),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: song.coverUrl,
                                            width: 114,
                                            height: 114,
                                            fit: BoxFit.cover,
                                            placeholder: (c, u) => Container(
                                              width: 114,
                                              height: 114,
                                              color: const Color(0xFF1F1F1F),
                                            ),
                                            errorWidget: (c, u, e) => Container(
                                              width: 114,
                                              height: 114,
                                              color: const Color(0xFF1F1F1F),
                                              child: const Icon(
                                                Icons.music_note,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          song.album,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _quickCard(
    String title,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(6),
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
