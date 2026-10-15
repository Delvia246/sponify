import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/song.dart';

class PlaylistHeader extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String? coverUrl; // untuk playlist yang punya cover
  final List<Song> songs;
  final bool isLikedSongs;
  final bool isDailyMix;

  const PlaylistHeader({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    this.coverUrl,
    required this.songs,
    this.isLikedSongs = false,
    this.isDailyMix = false,
  });

  // Ambil artist unik (max 3) untuk "With ..."
  String _getArtistText() {
    if (songs.isEmpty) return 'Various Artists';
    final artists = <String>{};
    for (final s in songs) {
      if (s.artist.isNotEmpty) artists.add(s.artist);
      if (artists.length >= 3) break;
    }
    if (artists.isEmpty) return 'Various Artists';
    return 'With ${artists.join(', ')}';
  }

  // Total durasi dari semua lagu
  String _getTotalDuration() {
    int total = 0;
    for (final s in songs) {
      total += s.duration;
    }
    final hours = total ~/ 3600;
    final minutes = (total % 3600) ~/ 60;
    if (hours > 0) return '$hours j $minutes mnt';
    return '$minutes mnt';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.4),
            const Color(0xFF121212),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== COVER =====
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: coverUrl != null && coverUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: coverUrl!,
                        fit: BoxFit.cover,
                        placeholder: (c, u) => Container(
                          color: color,
                          child: Icon(icon, color: Colors.white, size: 80),
                        ),
                        errorWidget: (c, u, e) => Container(
                          color: color,
                          child: Icon(icon, color: Colors.white, size: 80),
                        ),
                      ),
                    )
                  : Icon(icon, color: Colors.white, size: 80),
            ),
          ),

          const SizedBox(height: 24),

          // ===== TITLE =====
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // ===== "WITH [ARTISTS]" =====
          Text(
            _getArtistText(),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // ===== "DIBUAT UNTUKMU" + description =====
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1DB954),
                ),
                child: const Icon(Icons.person, color: Colors.black, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Dibuat untukmu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Tentang rekomendasi dan pengaruh promosi',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),

          const SizedBox(height: 10),

          // ===== JUMLAH LAGU • DURASI =====
          Text(
            '${songs.length} lagu • ${_getTotalDuration()}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
