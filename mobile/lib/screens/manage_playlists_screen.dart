import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../widgets/song_artwork.dart';

class ManagePlaylistsScreen extends StatefulWidget {
  final List<Playlist> playlists;
  const ManagePlaylistsScreen({super.key, required this.playlists});

  @override
  State<ManagePlaylistsScreen> createState() => _ManagePlaylistsScreenState();
}

class _ManagePlaylistsScreenState extends State<ManagePlaylistsScreen> {
  final Set<int> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Playlist di profilmu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Pilih playlist yang akan dihapus dari profilmu. Playlist baru akan otomatis ditampilkan di profil.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  if (_selectedIds.length == widget.playlists.length) {
                    _selectedIds.clear();
                  } else {
                    _selectedIds.addAll(widget.playlists.map((e) => e.id));
                  }
                });
              },
              icon: Icon(
                _selectedIds.length == widget.playlists.length
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: Colors.white,
              ),
              label: const Text(
                'Pilih semua',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF282828),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.playlists.length,
              itemBuilder: (context, index) {
                final p = widget.playlists[index];
                final isSelected = _selectedIds.contains(p.id);
                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedIds.add(p.id);
                        } else {
                          _selectedIds.remove(p.id);
                        }
                      });
                    },
                    activeColor: const Color(0xFF1DB954),
                  ),
                  title: Row(
                    children: [
                      SongArtwork(
                        imageUrl: '',
                        size: 48,
                        borderRadius: 4,
                        fallbackIcon: Icons.music_note,
                      ), // Placeholder
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${p.songCount} lagu • Publik',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
