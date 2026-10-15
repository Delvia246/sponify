import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/song.dart';
import '../services/mood_service.dart';
import '../services/player_service.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  static const List<Map<String, dynamic>> _moods = [
    {
      'key': 'happy',
      'label': 'Happy',
      'emoji': '😊',
      'color': Color(0xFFFFC107),
    },
    {
      'key': 'sad',
      'label': 'Sad',
      'emoji': '😢',
      'color': Color(0xFF2196F3),
    },
    {
      'key': 'chill',
      'label': 'Chill',
      'emoji': '😌',
      'color': Color(0xFF00BCD4),
    },
    {
      'key': 'workout',
      'label': 'Workout',
      'emoji': '💪',
      'color': Color(0xFFE91E63),
    },
    {
      'key': 'party',
      'label': 'Party',
      'emoji': '🎉',
      'color': Color(0xFF9C27B0),
    },
    {
      'key': 'focus',
      'label': 'Focus',
      'emoji': '🧠',
      'color': Color(0xFF4CAF50),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pilih Mood Kamu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Dapetin playlist instan sesuai perasaan kamu sekarang. Pilih emoji di bawah.',
                style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
              ),
            ),

            const SizedBox(height: 20),

            // Grid mood
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _moods.length,
                itemBuilder: (context, i) {
                  final mood = _moods[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _MoodPlaylistScreen(
                            moodKey: mood['key'],
                            moodLabel: mood['label'],
                            moodEmoji: mood['emoji'],
                            moodColor: mood['color'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            mood['color'],
                            mood['color'].withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (mood['color'] as Color)
                                .withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: Text(
                              mood['emoji'],
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mood['emoji'],
                                  style: const TextStyle(fontSize: 36),
                                ),
                                Text(
                                  mood['label'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ HALAMAN HASIL MOOD ============
class _MoodPlaylistScreen extends StatefulWidget {
  final String moodKey;
  final String moodLabel;
  final String moodEmoji;
  final Color moodColor;

  const _MoodPlaylistScreen({
    required this.moodKey,
    required this.moodLabel,
    required this.moodEmoji,
    required this.moodColor,
  });

  @override
  State<_MoodPlaylistScreen> createState() => _MoodPlaylistScreenState();
}

class _MoodPlaylistScreenState extends State<_MoodPlaylistScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final songs = await MoodService().getSongsByMood(widget.moodKey);
    if (!mounted) return;
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _playSong(int index) async {
    await PlayerService().playPlaylist(_songs, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1DB954)),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 240,
                    backgroundColor: widget.moodColor,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.moodColor,
                              const Color(0xFF121212),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.moodEmoji,
                              style: const TextStyle(fontSize: 70),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${widget.moodLabel} Mood',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_songs.length} lagu',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Play all button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_songs.isEmpty) return;
                              PlayerService().playPlaylist(_songs, 0);
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1DB954),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 34,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.shuffle,
                                color: Color(0xFF1DB954)),
                            onPressed: () {
                              if (_songs.isEmpty) return;
                              final shuffled = List<Song>.from(_songs)
                                ..shuffle();
                              PlayerService().playPlaylist(shuffled, 0);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // List lagu
                  _songs.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'Belum ada lagu untuk mood ini',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final song = _songs[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: song.coverUrl,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    placeholder: (c, u) => Container(
                                      width: 52,
                                      height: 52,
                                      color: const Color(0xFF282828),
                                      child: const Icon(Icons.music_note,
                                          color: Colors.grey),
                                    ),
                                    errorWidget: (c, u, e) => Container(
                                      width: 52,
                                      height: 52,
                                      color: const Color(0xFF282828),
                                      child: const Icon(Icons.music_note,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  song.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  song.artist,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  song.formattedDuration,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                onTap: () => _playSong(index),
                              );
                            },
                            childCount: _songs.length,
                          ),
                        ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }
}