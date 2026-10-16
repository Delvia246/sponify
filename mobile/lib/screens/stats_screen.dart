import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/stats_service.dart';
import '../services/session_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;

    final stats = await StatsService().getStats(userId);
    if (!mounted) return;
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}j ${minutes}m';
    }
    return '${minutes}m';
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
            : _stats == null
                ? const Center(
                    child: Text('Gagal memuat statistik',
                        style: TextStyle(color: Colors.white)),
                  )
                : CustomScrollView(
                    slivers: [
                      // === HEADER dengan gradient ===
                      SliverAppBar(
                        pinned: true,
                        expandedHeight: 240,
                        backgroundColor: const Color(0xFF1A3D2E),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1DB954),
                                  Color(0xFF0D6B32),
                                  Color(0xFF121212),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  24, 80, 24, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.insights,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Statistik Kamu',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Lebih baik dari Spotify Wrapped — real-time!',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // === 3 KARTU UTAMA ===
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              _statCard(
                                _stats!['total_plays'].toString(),
                                'Total Putar',
                                Icons.play_circle_outline,
                                const Color(0xFF1DB954),
                              ),
                              const SizedBox(width: 8),
                              _statCard(
                                _stats!['unique_songs'].toString(),
                                'Lagu Unik',
                                Icons.library_music_outlined,
                                const Color(0xFF00BCD4),
                              ),
                              const SizedBox(width: 8),
                              _statCard(
                                _formatDuration(_stats!['total_duration']),
                                'Total Durasi',
                                Icons.timer_outlined,
                                const Color(0xFFFF9800),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // === TOP ARTISTS ===
                      if ((_stats!['top_artists'] as List).isNotEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                            child: Text(
                              'Top Artis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: (_stats!['top_artists'] as List).length,
                              itemBuilder: (context, i) {
                                final a = _stats!['top_artists'][i];
                                return Container(
                                  width: 130,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: a['image_url'] ?? '',
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          placeholder: (c, u) => Container(
                                            width: 110,
                                            height: 110,
                                            color: const Color(0xFF282828),
                                            child: const Icon(Icons.person,
                                                color: Colors.grey),
                                          ),
                                          errorWidget: (c, u, e) => Container(
                                            width: 110,
                                            height: 110,
                                            color: const Color(0xFF282828),
                                            child: const Icon(Icons.person,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        a['artist'] ?? '-',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${a['play_count']}x putar',
                                        style: const TextStyle(
                                          color: Color(0xFFB3B3B3),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],

                      // === TOP ALBUMS ===
                      if ((_stats!['top_albums'] as List).isNotEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                            child: Text(
                              'Top Album',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: (_stats!['top_albums'] as List).length,
                              itemBuilder: (context, i) {
                                final al = _stats!['top_albums'][i];
                                return Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: al['cover_url'] ?? '',
                                          width: 140,
                                          height: 140,
                                          fit: BoxFit.cover,
                                          placeholder: (c, u) => Container(
                                            width: 140,
                                            height: 140,
                                            color: const Color(0xFF282828),
                                          ),
                                          errorWidget: (c, u, e) => Container(
                                            width: 140,
                                            height: 140,
                                            color: const Color(0xFF282828),
                                            child: const Icon(Icons.album,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        al['album'] ?? '-',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${al['play_count']}x putar',
                                        style: const TextStyle(
                                          color: Color(0xFFB3B3B3),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],

                      // === TOP SONGS (List) ===
                      if ((_stats!['top_songs'] as List).isNotEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                            child: Text(
                              'Top Lagu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final s = _stats!['top_songs'][i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                leading: SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF1DB954),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  s['title'] ?? '-',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  s['artist'] ?? '-',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                trailing: Text(
                                  '${s['play_count']}x',
                                  style: const TextStyle(
                                    color: Color(0xFF1DB954),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            childCount: (_stats!['top_songs'] as List).length,
                          ),
                        ),
                      ],

                      // Kalau kosong
                      if ((_stats!['top_songs'] as List).isEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'Belum ada riwayat mendengarkan.\nPutar lagu untuk mulai catat statistik.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),

                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
      ),
    );
  }

  Widget _statCard(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}