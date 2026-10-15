import 'package:flutter/material.dart';

import '../models/song.dart';

class SongOptionsSheet extends StatelessWidget {
  final Song song;
  final VoidCallback? onLike;
  final bool isLiked;

  const SongOptionsSheet({
    super.key,
    required this.song,
    this.onLike,
    this.isLiked = false,
  });

  static void show(
    BuildContext context,
    Song song, {
    VoidCallback? onLike,
    bool isLiked = false,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        // Tap di luar sheet → tutup
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GestureDetector(
                // Tap di dalam sheet → jangan tutup
                onTap: () {},
                child: SongOptionsSheet(
                  song: song,
                  onLike: onLike,
                  isLiked: isLiked,
                ),
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
        decoration: const BoxDecoration(
          color: Color(0xFF282828),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
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

              // Header: Cover + Info
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.grey),
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
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            style: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF3E3E3E), height: 20),

              _menuItem(
                context,
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                iconColor: isLiked ? const Color(0xFF1DB954) : Colors.white,
                title: isLiked
                    ? 'Hapus dari Liked Songs'
                    : 'Tambahkan ke Liked Songs',
                onTap: () {
                  Navigator.pop(context);
                  if (onLike != null) onLike!();
                },
              ),

              _menuItem(
                context,
                icon: Icons.playlist_add,
                title: 'Tambahkan ke playlist',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur tambah ke playlist segera hadir'),
                    ),
                  );
                },
              ),

              _menuItem(
                context,
                icon: Icons.queue_music,
                title: 'Tambahkan ke antrean',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lagu ditambahkan ke antrean'),
                    ),
                  );
                },
              ),

              _menuItem(
                context,
                icon: Icons.album,
                title: 'Buka album',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buka album ${song.album}')),
                  );
                },
              ),

              _menuItem(
                context,
                icon: Icons.person,
                title: 'Buka artis',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buka artis ${song.artist}')),
                  );
                },
              ),

              _menuItem(
                context,
                icon: Icons.share,
                title: 'Bagikan',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur bagikan segera hadir')),
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
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
    Color iconColor = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24),
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
}
