import 'package:flutter/material.dart';

import '../models/song.dart';

class SponifyCodeSheet extends StatelessWidget {
  final Song? song;
  const SponifyCodeSheet({super.key, this.song});

  static void show(BuildContext context, {Song? song}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: GestureDetector(
                onTap: () {},
                child: SponifyCodeSheet(song: song),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63), // Warna pink Spotify
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cover
          if (song != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                song!.coverUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 250,
                  color: Colors.black26,
                  child: const Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Waveform
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF282828),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.music_note, color: Colors.white),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(20, (i) {
                      final heights = [
                        12.0,
                        20.0,
                        16.0,
                        24.0,
                        14.0,
                        28.0,
                        18.0,
                        22.0,
                        10.0,
                        26.0,
                        15.0,
                        20.0,
                        12.0,
                        25.0,
                        17.0,
                        22.0,
                        14.0,
                        28.0,
                        18.0,
                        12.0,
                      ];
                      return Container(
                        width: 2,
                        height: heights[i],
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      );
                    }),
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
