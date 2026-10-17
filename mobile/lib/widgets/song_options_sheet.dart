import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/liked_service.dart';
import '../services/player_service.dart';
import '../services/session_service.dart';
import '../screens/lyrics_screen.dart';
import '../screens/album_screen.dart';
import '../screens/artist_screen.dart';
import 'add_to_playlist_sheet.dart';
import 'queue_sheet.dart';
import 'sleep_timer_sheet.dart';
import 'share_sheet.dart';
import 'sponify_code_sheet.dart';
import 'credits_sheet.dart';

class SongOptionsSheet extends StatefulWidget {
  final Song song;

  const SongOptionsSheet({super.key, required this.song});

  static void show(BuildContext context, Song song) {
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
                child: SongOptionsSheet(song: song),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<SongOptionsSheet> createState() => _SongOptionsSheetState();
}

class _SongOptionsSheetState extends State<SongOptionsSheet> {
  bool _isLiked = false;
  bool _isLoadingLike = true;
  bool _isToggling = false;
  int _userId = 1;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    final user = await SessionService.getUser();
    _userId = user?.id ?? 1;
    final liked = await LikedService().isLiked(_userId, widget.song.id);
    if (!mounted) return;
    setState(() {
      _isLiked = liked;
      _isLoadingLike = false;
    });
  }

  Future<void> _toggleLike() async {
    if (_isToggling) return;
    setState(() => _isToggling = true);
    final result = await LikedService().toggleLike(_userId, widget.song.id);

    if (!mounted) return;
    setState(() {
      _isLiked = result;
      _isToggling = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result ? 'Ditambahkan ke Liked Songs' : 'Dihapus dari Liked Songs',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: result
            ? const Color(0xFF1DB954)
            : const Color(0xFF282828),
      ),
    );
  }

  void _addToQueue() {
    PlayerService().addToQueue(widget.song);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${widget.song.title}" ditambahkan ke antrean'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1DB954),
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

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        widget.song.coverUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 44,
                          height: 44,
                          color: const Color(0xFF1F1F1F),
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.song.title,
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
                            widget.song.artist,
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

              // Menu List
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // LIKE
                      if (!_isLoadingLike)
                        _menuItem(
                          icon: _isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor: _isLiked
                              ? const Color(0xFF1DB954)
                              : Colors.white,
                          title: _isLiked
                              ? 'Hapus dari Liked Songs'
                              : 'Tambahkan ke Liked Songs',
                          onTap: _isToggling ? null : _toggleLike,
                        ),

                      // SHARE
                      _menuItem(
                        icon: Icons.share,
                        title: 'Bagikan',
                        onTap: () {
                          Navigator.pop(context);
                          ShareSheet.show(context, widget.song);
                        },
                      ),

                      // LIRIK
                      _menuItem(
                        icon: Icons.lyrics_outlined,
                        title: 'Lirik',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LyricsScreen(),
                            ),
                          );
                        },
                      ),

                      // ADD TO PLAYLIST
                      _menuItem(
                        icon: Icons.playlist_add,
                        title: 'Tambahkan ke playlist',
                        onTap: () {
                          Navigator.pop(context);
                          AddToPlaylistSheet.show(context, widget.song);
                        },
                      ),

                      // HIDE IN PLAYLIST
                      _menuItem(
                        icon: Icons.close,
                        title: 'Sembunyikan di playlist ini',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Lagu disembunyikan dari playlist ini',
                              ),
                            ),
                          );
                        },
                      ),

                      // ADD TO QUEUE
                      _menuItem(
                        icon: Icons.playlist_add,
                        title: 'Tambahkan ke Antrean',
                        onTap: _addToQueue,
                      ),

                      // OPEN QUEUE
                      _menuItem(
                        icon: Icons.queue_music,
                        title: 'Buka Antrean',
                        onTap: () {
                          Navigator.pop(context);
                          QueueSheet.show(context);
                        },
                      ),

                      // OPEN ALBUM
                      _menuItem(
                        icon: Icons.album,
                        title: 'Buka album',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumScreen(
                                albumId: widget.song.albumId,
                                albumTitle: widget.song.album,
                                artistName: widget.song.artist,
                                coverUrl: widget.song.coverUrl,
                              ),
                            ),
                          );
                        },
                      ),

                      // OPEN ARTIST
                      _menuItem(
                        icon: Icons.person,
                        title: 'Buka artis',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistScreen(
                                artistId: widget.song.artistId,
                                artistName: widget.song.artist,
                              ),
                            ),
                          );
                        },
                      ),

                      // START JAM
                      _menuItem(
                        icon: Icons.people_outline,
                        title: 'Mulai Dengar Bareng',
                        isPremium: true,
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur Dengar Bareng segera hadir'),
                            ),
                          );
                        },
                      ),

                      // EXCLUDE
                      _menuItem(
                        icon: Icons.cancel_outlined,
                        title: 'Kecualikan lagu dari taste profile-mu',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Lagu dikecualikan dari taste profile',
                              ),
                            ),
                          );
                        },
                      ),

                      // SLEEP TIMER
                      _menuItem(
                        icon: Icons.timer_outlined,
                        title: 'Pengatur waktu tidur',
                        onTap: () {
                          Navigator.pop(context);
                          SleepTimerSheet.show(context);
                        },
                      ),

                      // RADIO LAGU
                      _menuItem(
                        icon: Icons.radio,
                        title: 'Buka radio lagu',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistScreen(
                                artistId: widget.song.artistId,
                                artistName: 'Radio ${widget.song.artist}',
                              ),
                            ),
                          );
                        },
                      ),

                      // LIHAT KREDIT LAGU
                      _menuItem(
                        icon: Icons.article_outlined,
                        title: 'Lihat kredit lagu',
                        onTap: () {
                          Navigator.pop(context);
                          CreditsSheet.show(context, widget.song);
                        },
                      ),

                      // SHOW CODE
                      _menuItem(
                        icon: Icons.graphic_eq,
                        title: 'Tampilkan Kode Sponify',
                        onTap: () {
                          Navigator.pop(context);
                          SponifyCodeSheet.show(context, song: widget.song);
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    Color iconColor = Colors.white,
    bool isPremium = false,
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
