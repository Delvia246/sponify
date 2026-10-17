import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Widget reusable untuk cover art dengan placeholder & error yang cantik.
class SongArtwork extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;
  final IconData fallbackIcon;
  final bool isCircle;

  const SongArtwork({
    super.key,
    required this.imageUrl,
    required this.size,
    this.borderRadius = 6,
    this.fallbackIcon = Icons.music_note,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getGradientColors(imageUrl);
    final placeholderWidget = _buildFallback(colors);

    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (c, u) => placeholderWidget,
      errorWidget: (c, u, e) => placeholderWidget,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      memCacheWidth: (size * 2).toInt(),
    );

    if (isCircle) {
      return ClipOval(
        child: SizedBox(width: size, height: size, child: imageWidget),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: size, height: size, child: imageWidget),
    );
  }

  Widget _buildFallback(List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          color: Colors.white.withValues(alpha: 0.5),
          size: size * 0.4,
        ),
      ),
    );
  }

  /// Generate warna konsisten dari URL string (hash-based)
  List<Color> _getGradientColors(String seed) {
    final palettes = [
      [const Color(0xFF1DB954), const Color(0xFF0D7A35)],
      [const Color(0xFF4B22F4), const Color(0xFF9C27B0)],
      [const Color(0xFFE91E63), const Color(0xFFC2185B)],
      [const Color(0xFF00BCD4), const Color(0xFF00838F)],
      [const Color(0xFFFF5722), const Color(0xFFBF360C)],
      [const Color(0xFF3949AB), const Color(0xFF1A237E)],
      [const Color(0xFF7B1FA2), const Color(0xFF4A148C)],
      [const Color(0xFF00695C), const Color(0xFF003D33)],
    ];
    final hash = seed.hashCode.abs();
    return palettes[hash % palettes.length];
  }
}
