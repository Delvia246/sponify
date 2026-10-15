import 'package:flutter/material.dart';

class PlaylistOptionsSheet extends StatelessWidget {
  final String playlistName;
  final int songCount;
  final String creator;

  const PlaylistOptionsSheet({
    super.key,
    required this.playlistName,
    required this.songCount,
    this.creator = 'oleh Sponify',
  });

  static void show(
    BuildContext context, {
    required String playlistName,
    required int songCount,
    String creator = 'oleh Sponify',
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GestureDetector(
                onTap: () {},
                child: PlaylistOptionsSheet(
                  playlistName: playlistName,
                  songCount: songCount,
                  creator: creator,
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
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4B22F4), Color(0xFF9C27B0)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.queue_music,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlistName,
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
                            '$creator • $songCount lagu',
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
                icon: Icons.share_outlined,
                title: 'Bagikan',
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Fitur bagikan segera hadir');
                },
              ),

              _menuItem(
                context,
                icon: Icons.add_circle_outline,
                title: 'Tambahkan ke Koleksi Kamu',
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Ditambahkan ke Koleksi Kamu');
                },
              ),

              _menuItem(
                context,
                icon: Icons.download_outlined,
                title: 'Download',
                isPremium: true,
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Fitur download segera hadir');
                },
              ),

              _menuItem(
                context,
                icon: Icons.queue_music,
                title: 'Tambahkan ke Antrean',
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Ditambahkan ke antrean');
                },
              ),

              _menuItem(
                context,
                icon: Icons.playlist_add,
                title: 'Tambahkan ke playlist lain',
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Fitur tambah ke playlist lain segera hadir');
                },
              ),

              _menuItem(
                context,
                icon: Icons.headphones,
                title: 'Mulai Dengar Bareng',
                isPremium: true,
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Fitur dengar bareng segera hadir');
                },
              ),

              _menuItem(
                context,
                icon: Icons.cancel_outlined,
                title: 'Kecualikan playlist dari taste profile-mu',
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Playlist dikecualikan');
                },
              ),

              _menuItem(
                context,
                icon: Icons.graphic_eq,
                title: 'Tampilkan Kode Sponify',
                onTap: () {
                  Navigator.pop(context);
                  _snack(context, 'Fitur kode Spotify segera hadir');
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isPremium
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1DB954),
                  ),
                  child: const Icon(Icons.check, color: Colors.black, size: 12),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Premium',
                  style: TextStyle(
                    color: Color(0xFF1DB954),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : null,
      onTap: onTap,
    );
  }
}
