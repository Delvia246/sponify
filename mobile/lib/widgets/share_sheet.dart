import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/song.dart';

class ShareSheet extends StatelessWidget {
  final Song song;

  const ShareSheet({super.key, required this.song});

  static void show(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareSheet(song: song),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
            // Card Preview
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    // Card Lagu
                    Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1E1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              song.coverUrl,
                              height: 188,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                height: 188,
                                color: Colors.black26,
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            song.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            song.artist,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Icon(
                                Icons.music_note,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Sponify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Card Teks (Opsional)
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1E1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${song.title}"',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: const [
                              Icon(
                                Icons.music_note,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Sponify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Toggle Lagu / Lirik
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF3E3E3E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Lagu',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Lirik',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Share Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _shareIcon(
                    Icons.link,
                    'Salin link',
                    Colors.grey.shade800,
                    () {
                      Clipboard.setData(
                        ClipboardData(
                          text: 'https://sponify.com/song/${song.id}',
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link disalin ke clipboard!'),
                          backgroundColor: Color(0xFF1DB954),
                        ),
                      );
                    },
                  ),
                  _shareIcon(
                    Icons.chat,
                    'WhatsApp',
                    const Color(0xFF25D366),
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka WhatsApp...')),
                      );
                    },
                  ),
                  _shareIcon(
                    Icons.camera_alt,
                    'Story',
                    const Color(0xFFE1306C),
                    () {},
                  ),
                  _shareIcon(Icons.sms, 'SMS', Colors.grey.shade700, () {}),
                  _shareIcon(
                    Icons.add_circle_outline,
                    'Status',
                    const Color(0xFF1DB954),
                    () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _shareIcon(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
