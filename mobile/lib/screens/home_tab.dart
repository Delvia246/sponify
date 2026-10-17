import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../widgets/phone_frame.dart';
import '../widgets/profile_menu_sheet.dart';
import '../widgets/song_artwork.dart'; // IMPORT BARU
import 'quick_playlist_screen.dart';
import 'music_screen.dart';
import 'podcast_screen.dart';

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

  void _openQuickPlaylist(
    String title,
    Color color,
    IconData icon, {
    bool useLikedSongs = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => phoneWrap(
          QuickPlaylistScreen(
            title: title,
            color: color,
            icon: icon,
            songs: _songs,
            useLikedSongs: useLikedSongs,
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
                                const SizedBox(width: 8),
                                const Text('Sponify', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                              ],
                            ),
                            const Spacer(),
                            IconButton(iconSize: 24, icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: _showNewReleases),
                            IconButton(iconSize: 24, icon: const Icon(Icons.people_outline, color: Colors.white), onPressed: _showListeningActivity),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: _showProfileMenu,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF1DB954), Color(0xFF1ED760)])),
                                child: const Icon(Icons.person, color: Colors.black, size: 22),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(_getGreeting(), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    // === FILTER CHIPS ===
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
                                    const SizedBox(height: 8),
                                    Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text(song.artist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // === KONTEN BERDASARKAN FILTER ===
                    if (_filterIndex == 0) ..._buildAllContent(),
                    if (_filterIndex == 1) ..._buildMusicContent(),
                    if (_filterIndex == 2) _buildPodcastContent(),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text('Recommended for you', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _songs.length,
                          itemBuilder: (context, i) {
                            final song = _songs[i];
                            return GestureDetector(
                              onTap: () => _playSong(i),
                              child: Container(
                                width: 130,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: CachedNetworkImage(
                                        imageUrl: song.coverUrl,
                                        width: 114,
                                        height: 114,
                                        fit: BoxFit.cover,
                                        placeholder: (c, u) => Container(width: 114, height: 114, color: const Color(0xFF1F1F1F)),
                                        errorWidget: (c, u, e) => Container(width: 114, height: 114, color: const Color(0xFF1F1F1F), child: const Icon(Icons.music_note, color: Colors.grey)),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(song.album, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                // Dikasih height 120 supaya lagu terakhir nggak ketutupan floating navbar
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
    );
  }

  // ============================================
  // FILTER "ALL"
  // ============================================
  List<Widget> _buildAllContent() {
    return [
      // QUICK PICKS
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
                  useLikedSongs: true,
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

      // TOP MIXES
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
                clipBehavior:
                    Clip.none, // FIX: Cegah card pertama terpotong di Web
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _songs.length > 5 ? 5 : _songs.length,
                itemBuilder: (context, i) {
                  final song = _songs[i];
                  return GestureDetector(
                    onTap: () => _playSong(i),
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'cover_${song.id}',
                            child: SongArtwork(
                              // GANTI: SongArtwork
                              imageUrl: song.coverUrl,
                              size: 150,
                              borderRadius: 6,
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

      // RECOMMENDED
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
                clipBehavior: Clip.none, // FIX
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SongArtwork(
                            // GANTI: SongArtwork
                            imageUrl: song.coverUrl,
                            size: 114,
                            borderRadius: 4,
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
    ];
  }

  // ============================================
  // FILTER "MUSIC"
  // ============================================
  List<Widget> _buildMusicContent() {
    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            'Semua Musik',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final song = _songs[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
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
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              song.formattedDuration,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () => _playSong(index),
          );
        }, childCount: _songs.length),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MusicScreen()),
              );
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: const Text(
              'Buka Halaman Musik Lengkap',
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // ============================================
  // FILTER "PODCASTS"
  // ============================================
  Widget _buildPodcastContent() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.podcasts,
                color: Colors.white.withValues(alpha: 0.3),
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Belum ada podcast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Podcast akan muncul di sini. Cek kembali nanti ya!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PodcastScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.explore_outlined, color: Colors.white),
                label: const Text(
                  'Buka Halaman Podcast',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
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