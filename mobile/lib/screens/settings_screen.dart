import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  // Akun Gratis + Beli Premium
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Akun Gratis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Beli Premium',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _settingItem(
                    Icons.person_outline,
                    'Akun',
                    'Nama pengguna • Tutup akun',
                  ),
                  _settingItem(
                    Icons.music_note_outlined,
                    'Konten dan tampilan',
                    'Canvas • Izinkan konten eksplisit',
                  ),
                  _settingItem(
                    Icons.lock_outline,
                    'Privasi dan sosial',
                    'Sesi pribadi • Playlist publik',
                  ),
                  _settingItem(
                    Icons.volume_up_outlined,
                    'Playback',
                    'Playback tanpa jeda • Autoplay',
                  ),
                  _settingItem(
                    Icons.notifications_none,
                    'Notifikasi',
                    'Push • Email',
                  ),
                  _settingItem(
                    Icons.phonelink_outlined,
                    'App dan perangkat',
                    'Google Maps • Impor dari app lain',
                  ),
                  _settingItem(
                    Icons.download_outlined,
                    'Mode hemat data dan offline',
                    'Mode hemat data • Download memakai data seluler',
                  ),
                  _settingItem(
                    Icons.equalizer,
                    'Kualitas media',
                    'Kualitas streaming Wi-Fi • Kualitas download audio',
                  ),
                  _settingItem(
                    Icons.feedback_outlined,
                    'Iklan',
                    'Iklan yang disesuaikan',
                  ),
                  _settingItem(
                    Icons.info_outline,
                    'Tentang dan dukungan',
                    'Versi • Kebijakan Privasi',
                  ),

                  const SizedBox(height: 24),

                  // Tombol Logout
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur keluar segera hadir'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () {},
    );
  }
}
