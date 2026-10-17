import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../models/user.dart';
import '../services/library_service.dart';
import '../services/session_service.dart';
import '../widgets/sponify_code_sheet.dart';
import 'edit_profile_screen.dart';
import 'manage_playlists_screen.dart';
import 'playlist_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  List<Playlist> _playlists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await SessionService.getUser();
    if (user == null) return;

    final playlists = await LibraryService().getPlaylists(user.id);
    if (!mounted) return;
    setState(() {
      _user = user;
      _playlists = playlists;
      _isLoading = false;
    });
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Color(0xFF282828),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Yang bisa dilihat orang lain',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF3E3E3E)),
            _settingSwitch(
              'Pengikut dan mengikuti',
              'Di profilmu, orang bisa melihat siapa yang mengikutimu dan siapa yang kamu ikuti.',
              true,
            ),
            _settingSwitch(
              'Playlist',
              'Orang bisa melihat playlist yang kamu tambahkan ke profilmu.',
              true,
            ),
            _settingSwitch(
              'Artis yang baru diputar',
              'Orang bisa melihat siapa yang baru-baru ini kamu dengarkan di profilmu.',
              false,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text(
                'Lihat semua pengaturan privasi dan sosial',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF282828),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Colors.white),
                title: const Text(
                  'Bagikan',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  'Sembunyikan aktivitas mendengarkannya',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  'Lihat pratinjau profil',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.graphic_eq, color: Colors.white),
                title: const Text(
                  'Tampilkan Kode Sponify',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  SponifyCodeSheet.show(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingSwitch(String title, String subtitle, bool initialValue) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      value: initialValue,
      activeThumbColor: const Color(0xFF1DB954),
      onChanged: (val) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1DB954)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: const Color(0xFF2E1A47),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4A148C), Color(0xFF121212)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black26,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _user?.username ?? 'Pengguna',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // FIX: Ubah 3 pengikut menjadi 0 pengikut
                                const Text(
                                  '0 pengikut • 0 mengikuti',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  OutlinedButton(
                    // FIX: Tambahkan async dan await agar me-refresh data setelah kembali
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                      _loadData(); // Panggil ulang data terbaru
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _showSettingsSheet,
                    icon: const Icon(Icons.settings, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: _showProfileOptionsSheet,
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Playlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManagePlaylistsScreen(playlists: _playlists),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                    label: const Text(
                      'Kelola',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_playlists.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'Belum ada playlist',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final p = _playlists[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.queue_music,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${p.songCount} kali disimpan',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistDetailScreen(
                          playlistId: p.id,
                          playlistName: p.name,
                        ),
                      ),
                    );
                  },
                );
              }, childCount: _playlists.length),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
