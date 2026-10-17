import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../models/song.dart';
import '../services/library_service.dart';
import '../services/session_service.dart';

class AddToPlaylistSheet extends StatefulWidget {
  final Song song;

  const AddToPlaylistSheet({super.key, required this.song});

  static void show(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GestureDetector(
                onTap: () {},
                child: AddToPlaylistSheet(song: song),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  List<Playlist> _playlists = [];
  bool _isLoading = true;
  int? _addingToId;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;
    final playlists = await LibraryService().getPlaylists(userId);
    if (!mounted) return;
    setState(() {
      _playlists = playlists;
      _isLoading = false;
    });
  }

  Future<void> _addToPlaylist(Playlist playlist) async {
    setState(() => _addingToId = playlist.id);
    final success = await LibraryService().addSongToPlaylist(
      playlist.id,
      widget.song.id,
    );
    if (!mounted) return;

    setState(() => _addingToId = null);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ditambahkan ke "${playlist.name}"'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF1DB954),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan ke playlist'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambahkan ke playlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.song.title,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFF3E3E3E), height: 1),

              // Body
              Flexible(
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1DB954),
                          ),
                        ),
                      )
                    : _playlists.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.queue_music,
                              color: Colors.grey,
                              size: 48,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Belum ada playlist.\nBuat playlist dulu di Library.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: _playlists.length,
                        itemBuilder: (context, index) {
                          final p = _playlists[index];
                          final isAdding = _addingToId == p.id;

                          return ListTile(
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1F1F),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.queue_music,
                                color: Color(0xFF1DB954),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              p.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${p.songCount} lagu',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            trailing: isAdding
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF1DB954),
                                    ),
                                  )
                                : const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white70,
                                  ),
                            onTap: isAdding ? null : () => _addToPlaylist(p),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
