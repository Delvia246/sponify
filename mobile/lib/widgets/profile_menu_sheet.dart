import 'package:flutter/material.dart';

import '../services/session_service.dart';
import '../screens/recently_played_screen.dart';
import '../screens/whats_new_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/welcome_screen.dart'; // IMPORT BARU
import 'phone_frame.dart';

class ProfileMenuSheet extends StatelessWidget {
  const ProfileMenuSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GestureDetector(
                onTap: () {},
                child: const ProfileMenuSheet(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // === PROFILE HEADER ===
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => phoneWrap(const ProfileScreen()),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0xFF1DB954),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FutureBuilder(
                          future: SessionService.getUser(),
                          builder: (context, snap) {
                            final user = snap.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.username ?? 'Pengguna',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Lihat profil',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // === TAMBAH AKUN ===
                ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1.5),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                  title: const Text(
                    'Tambah akun',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Arahkan ke WelcomeScreen untuk login dengan akun baru
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                ),

                const Divider(color: Color(0xFF3E3E3E), height: 1),

                // === MENU UTAMA ===
                _menuItem(
                  context,
                  icon: Icons.history,
                  title: 'Baru Diputar',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            phoneWrap(const RecentlyPlayedScreen()),
                      ),
                    );
                  },
                ),

                _menuItem(
                  context,
                  icon: Icons.insights,
                  title: 'Statistik Kamu',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => phoneWrap(const StatsScreen()),
                      ),
                    );
                  },
                ),

                _menuItem(
                  context,
                  icon: Icons.campaign_outlined,
                  title: 'Info Terkini',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => phoneWrap(const WhatsNewScreen()),
                      ),
                    );
                  },
                ),
                _menuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Pengaturan dan privasi',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => phoneWrap(const SettingsScreen()),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // === ACTIVITIES ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _activityItem(
                        'Aktivitas',
                        'Aktifkan',
                        Icons.person,
                        () {},
                      ),
                      const SizedBox(width: 20),
                      _activityItem(
                        'dinzy',
                        'All I Need',
                        Icons.play_circle_outline,
                        () {},
                      ),
                      const SizedBox(width: 20),
                      _activityItem('Undang', 'teman-tem...', Icons.add, () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // === PESAN SECTION ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pesan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Pesan dummy
                _messageItem(
                  'dinzy',
                  'Mengirimkan • 29 Jul',
                  'All I Need To Hear – The 1975',
                ),
                _messageItem('yummy', 'Mengirimkan • 8 Jul', ''),

                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2A2A2A),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Pesan baru',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onTap: () {},
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _activityItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1.5),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageItem(String name, String time, String preview) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 22,
        backgroundColor: Color(0xFF2A2A2A),
        child: Icon(Icons.person, color: Colors.white, size: 20),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          if (preview.isNotEmpty)
            Text(
              preview,
              style: const TextStyle(
                color: Color(0xFF1DB954),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
      onTap: () {},
    );
  }
}
