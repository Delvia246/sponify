import 'package:flutter/material.dart';

import '../models/song.dart';

class CreditsSheet extends StatelessWidget {
  final Song song;
  const CreditsSheet({super.key, required this.song});

  static void show(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CreditsSheet(song: song),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
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
            Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              song.artist,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF3E3E3E)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Artis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      song.artist,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Artis Utama',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Ikuti',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Produksi & Teknis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _creditItem('Produser', 'Sponify Studio'),
                  _creditItem('Teknisi Rekaman', song.artist),
                  _creditItem('Teknisi Mixing', 'Lo-Fi Chill'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _creditItem(String role, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(role, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
