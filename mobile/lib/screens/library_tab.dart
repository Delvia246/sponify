import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../services/library_service.dart';
import '../services/session_service.dart';
import '../widgets/profile_menu_sheet.dart';
import '../widgets/song_artwork.dart'; // IMPORT BARU
import 'playlist_detail_screen.dart';
import 'quick_playlist_screen.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => LibraryTabState();
}

class LibraryTabState extends State<LibraryTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _filterIndex = 0;
  final List<String> _filters = ['Playlist', 'Artis', 'Album'];

  List<Playlist> _playlists = [];
  List<Artist> _artists = [];
  List<Album> _albums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _filterIndex = _tabController.index);
    });
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> reload() async {
    await _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    final user = await SessionService.getUser();
    final userId = user?.id ?? 1;

    final playlists = await LibraryService().getPlaylists(userId);
    final artists = await LibraryService().getArtists();
    final albums = await LibraryService().getAlbums();

    if (!mounted) return;
    setState(() {
      _playlists = playlists;
      _artists = artists;
      _albums = albums;
      _isLoading = false;
    });
  }

  Future<void> _showCreatePlaylistDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text(
          'Buat Playlist Baru',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nama Playlist',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Deskripsi (opsional)',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Buat',
              style: TextStyle(color: Color(0xFF1DB954)),
            ),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      final user = await SessionService.getUser();
      final userId = user?.id ?? 1;

      final success = await LibraryService().createPlaylist(
        userId,
        nameController.text.trim(),
        descController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist berhasil dibuat!')),
        );
        _loadAll();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal bikin playlist')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER ===
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => ProfileMenuSheet.show(context),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF1DB954),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Koleksi Kamu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _showCreatePlaylistDialog,
                  ),
                ],
              ),
            ),

            // === FILTER ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _filterIndex == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_filters[i]),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _filterIndex = i);
                        _tabController.index = i;
                      },
                      backgroundColor: const Color(0xFF282828),
                      selectedColor: const Color(0xFF1DB954),
                      labelStyle: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide.none,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            // === BODY ===
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DB954),
                      ),
                    )
                  : IndexedStack(
                      index: _filterIndex,
                      children: [
                        _buildPlaylists(),
                        _buildArtists(),
                        _buildAlbums(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // TAB PLAYLIST
  // ============================================
  Widget _buildPlaylists() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        // === TILE "LIKED SONGS" ===
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4B22F4), Color(0xFF9C27B0)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 26),
          ),
          title: const Text(
            'Liked Songs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: const Text(
            'Playlist • Otomatis',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuickPlaylistScreen(
                  title: 'Liked Songs',
                  color: Color(0xFF4B22F4),
                  icon: Icons.favorite,
                  songs: [],
                  useLikedSongs: true,
                ),
              ),
            );
          },
        ),

        const Divider(color: Color(0xFF282828), height: 20),

        // === PLAYLIST USER ===
        if (_playlists.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Belum ada playlist.\nTekan + untuk buat playlist baru.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ..._playlists.map((p) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              leading: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.queue_music,
                  color: Color(0xFF1DB954),
                  size: 26,
                ),
              ),
              title: Text(
                p.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                'Playlist • ${p.songCount} lagu',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistDetailScreen(
                      playlistId: p.id,
                      playlistName: p.name,
                    ),
                  ),
                );
              },
            );
          }),
      ],
    );
  }

  Widget _buildArtists() {
    if (_artists.isEmpty) {
      return const Center(
        child: Text('Belum ada artis', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _artists.length,
      itemBuilder: (context, index) {
        final a = _artists[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          leading: SongArtwork(
            // GANTI: SongArtwork
            imageUrl: a.imageUrl,
            size: 52,
            isCircle: true,
            fallbackIcon: Icons.person,
          ),
          title: Text(
            a.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            'Artis • ${a.albumCount} album',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detail ${a.name} segera hadir')),
            );
          },
        );
      },
    );
  }

  Widget _buildAlbums() {
    if (_albums.isEmpty) {
      return const Center(
        child: Text('Belum ada album', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final al = _albums[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          leading: SongArtwork(
            // GANTI: SongArtwork
            imageUrl: al.coverUrl,
            size: 52,
            borderRadius: 4,
            fallbackIcon: Icons.album,
          ),
          title: Text(
            al.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            '${al.artist} • ${al.releaseYear} • ${al.songCount} lagu',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detail ${al.title} segera hadir')),
            );
          },
        );
      },
    );
  }
}
