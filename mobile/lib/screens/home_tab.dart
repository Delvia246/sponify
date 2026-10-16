import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../services/session_service.dart';
import '../widgets/phone_frame.dart';
<<<<<<< HEAD
import '../widgets/profile_menu_sheet.dart';
import 'quick_playlist_screen.dart';
=======
import 'profile_screen.dart';
import 'login_screen.dart';
import 'liked_songs_screen.dart';
import 'stats_screen.dart';
import 'mood_screen.dart';
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2

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

<<<<<<< HEAD
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
=======
  // ============ FITUR 1: Activity Modal ============
  void _showListeningActivity() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aktivitas mendengarkan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Izinkan teman dan pengikut di Sponify melihat apa yang kamu dengarkan.',
                  style: TextStyle(
                      color: Color(0xFFB3B3B3), fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                _activityRow(),
                _activityRow(),
                _activityRow(),
                const SizedBox(height: 24),
                const Text(
                  'Buka Pengaturan > Aktivitas mendengarkan dan wawasan, lalu aktifkan Aktivitas mendengarkan. Kamu bisa menonaktifkannya kapan saja.',
                  style: TextStyle(
                      color: Color(0xFFB3B3B3), fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Pengaturan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _activityRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF3E3E3E),
                child: Icon(Icons.person, color: Colors.grey, size: 24),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D4D4D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D4D4D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ FITUR 2: Notification Panel ============
  void _showNewReleases() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DefaultTabController(
        length: 2,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Yang Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rilis terbaru dari artis, podcast, dan acara yang kamu ikuti.',
                      style:
                          TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const TabBar(
                  indicatorColor: Color(0xFF1DB954),
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xFFB3B3B3),
                  tabs: [
                    Tab(text: 'Musik'),
                    Tab(text: 'Podcast & Acara'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildNewReleases(),
                      const Center(
                        child: Text(
                          'Belum ada podcast baru',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
          ),
        ),
      ),
    );
<<<<<<< HEAD
=======
  }

  Widget _buildNewReleases() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: song.coverUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (c, u) => Container(
                        width: 70,
                        height: 70,
                        color: const Color(0xFF282828),
                      ),
                      errorWidget: (c, u, e) => Container(
                        width: 70,
                        height: 70,
                        color: const Color(0xFF282828),
                        child: const Icon(Icons.music_note, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song.artist,
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Single • ${song.album}',
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill,
                        color: Colors.white, size: 36),
                    onPressed: () {
                      PlayerService().playPlaylist(_songs, index);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ============ FITUR 3: Profile Dropdown Menu ============
  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              _menuItem(Icons.person_outline, 'Akun', () {
                Navigator.pop(context);
              }),
              _menuItem(Icons.account_circle_outlined, 'Profil', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }),
              _menuItem(Icons.new_releases_outlined, 'Terbaru', () {
                Navigator.pop(context);
              }),
              _menuItem(
                  Icons.workspace_premium_outlined, 'Upgrade ke Premium', () {
                Navigator.pop(context);
              }),
              _menuItem(Icons.help_outline, 'Dukungan', () {
                Navigator.pop(context);
              }),
              _menuItem(Icons.lock_outline, 'Sesi pribadi', () {
                Navigator.pop(context);
              }),
              _menuItem(Icons.settings_outlined, 'Pengaturan', () {
                Navigator.pop(context);
              }),
              _menuItem(Icons.refresh, 'Perbarui Sponify sekarang', () {
                Navigator.pop(context);
              }),
              const Divider(color: Color(0xFF3E3E3E), height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleLogout();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text('Keluar', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Yakin mau keluar dari akun ini?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar',
                style: TextStyle(color: Color(0xFF1DB954))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SessionService.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => phoneWrap(const LoginScreen())),
        (route) => false,
      );
    }
  }

  void _playSong(int index) async {
    await PlayerService().playPlaylist(_songs, index);
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
  }

  // ============ FITUR 4: Liked Songs ============
  void _openLikedSongs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LikedSongsScreen(),
      ),
    );
  }

  // ============ FITUR 5: Stats ============
  void _openStats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StatsScreen(),
      ),
    );
  }

  // ============ FITUR 6: Mood ============
  void _openMood() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MoodScreen(),
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
                    // === HEADER BARU dengan 3 IKON ===
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
<<<<<<< HEAD
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
=======
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
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
                                const Spacer(),
                                IconButton(
                                  iconSize: 24,
                                  icon: const Icon(Icons.notifications_none,
                                      color: Colors.white),
                                  onPressed: _showNewReleases,
                                ),
                                IconButton(
                                  iconSize: 24,
                                  icon: const Icon(Icons.people_outline,
                                      color: Colors.white),
                                  onPressed: _showListeningActivity,
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: _showProfileMenu,
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

<<<<<<< HEAD
                    // === QUICK PICKS ===
=======
                    // === GRID (4 kartu bisa dipencet) ===
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
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
<<<<<<< HEAD
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
=======
                            GestureDetector(
                              onTap: _openLikedSongs,
                              child: _quickCard('Liked Songs',
                                  const Color(0xFF4B22F4), Icons.favorite),
                            ),
                            _quickCard('Daily Mix 1', const Color(0xFFE91E63),
                                Icons.radio),
                            _quickCard('Chill Vibes', const Color(0xFF00BCD4),
                                Icons.nightlight_round),
                            GestureDetector(
                              onTap: _openStats,
                              child: _quickCard('Statistik',
                                  const Color(0xFFFF5722), Icons.trending_up),
                            ),
                            GestureDetector(
                              onTap: _openMood,
                              child: _quickCard('Mood',
                                  const Color(0xFF9C27B0), Icons.mood),
                            ),
                            _quickCard('New Releases', const Color(0xFF4CAF50),
                                Icons.new_releases),
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
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
