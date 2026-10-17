import 'package:flutter/material.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

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
                    'Podcast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Podcast',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Episodes to try',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // List podcast (dummy)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _podcastCard(
                    context,
                    title: 'Speaking Politely',
                    subtitle:
                        'Slow English Podcast | Episode 226 | English With Us',
                    tag: 'A1-A2',
                    color: const Color(0xFF3949AB),
                  ),
                  _podcastCard(
                    context,
                    title: 'Boost Your Spoken English Quickly',
                    subtitle: 'Talk Smoothly and With Confidence',
                    tag: 'A2-B1',
                    color: const Color(0xFFD32F2F),
                  ),
                  _podcastCard(
                    context,
                    title: 'Daily Conversation Practice',
                    subtitle: 'Belajar ngobrol sehari-hari',
                    tag: 'A1-A2',
                    color: const Color(0xFF00897B),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _podcastCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String tag,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Stack(
              children: [
                // Tag badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Play button
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1DB954),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                ),
                // Icon
                const Center(
                  child: Icon(Icons.podcasts, color: Colors.white24, size: 70),
                ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
