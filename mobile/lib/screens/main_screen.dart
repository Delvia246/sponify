import 'package:flutter/material.dart';

import 'home_tab.dart';
import 'search_tab.dart';
import 'library_tab.dart';
import 'premium_tab.dart';
import 'blend_screen.dart';
import '../services/library_service.dart';
import '../services/session_service.dart';
import '../widgets/mini_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<LibraryTabState> _libraryKey = GlobalKey<LibraryTabState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const HomeTab(),
      const SearchTab(),
      LibraryTab(key: _libraryKey),
      const PremiumTab(),
      const SizedBox.shrink(), // Placeholder untuk Create
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: IndexedStack(
        index: _currentIndex == 4
            ? 0
            : _currentIndex, // Create (4) tidak punya halaman
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF000000)),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MiniPlayer(), // Mini player melayang di atas nav
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(0, Icons.home_filled, 'Home'),
                    _navItem(1, Icons.search, 'Search'),
                    _navItem(2, Icons.library_music_outlined, 'Library'),
                    _navItem(3, Icons.workspace_premium_outlined, 'Premium'),
                    _navItem(
                      4,
                      Icons.add_box_outlined,
                      'Create',
                      isCreate: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData icon,
    String label, {
    bool isCreate = false,
  }) {
    final isSelected = _currentIndex == index;

    // Warna: Putih untuk aktif, Abu-abu untuk tidak aktif
    final color = isSelected ? Colors.white : const Color(0xFFB3B3B3);

    return GestureDetector(
      onTap: () async {
        if (isCreate) {
          await _showCreateSheet();
          return;
        }
        setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === BOTTOM SHEET CREATE ===
  Future<void> _showCreateSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => GestureDetector(
        onTap: () => Navigator.pop(sheetContext),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GestureDetector(
                onTap: () {},
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          _sheetOption(
                            sheetContext,
                            icon: Icons.music_note,
                            title: 'Playlist',
                            subtitle: 'Buat playlist berisi lagu atau episode',
                            onTap: () async {
                              Navigator.pop(sheetContext);
                              await _showCreatePlaylistDialog();
                            },
                          ),
                          _sheetOption(
                            sheetContext,
                            icon: Icons.people_alt,
                            title: 'Playlist kolaboratif',
                            subtitle: 'Buat playlist bersama teman',
                            onTap: () async {
                              Navigator.pop(sheetContext);
                              await _showCreateCollaborativeDialog();
                            },
                          ),
                          _sheetOption(
                            sheetContext,
                            icon: Icons.compare_arrows,
                            title: 'Blend',
                            subtitle: 'Satukan selera musik teman-temanmu dalam sebuah playlist',
                            onTap: () {
                              Navigator.pop(sheetContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BlendScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetOption(
    BuildContext sheetContext, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2A2A2A),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === DIALOG PLAYLIST BIASA ===
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
        setState(() => _currentIndex = 2);
        _libraryKey.currentState?.reload();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal bikin playlist')));
      }
    }
  }

  // === DIALOG PLAYLIST KOLABORATIF ===
  Future<void> _showCreateCollaborativeDialog() async {
    final nameController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Beri nama playlist kolaboratifmu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Playlist #14 kami',
                hintStyle: TextStyle(
                  color: Colors.grey.withValues(alpha: 0.5),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1DB954), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Batal', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Buat',
              style: TextStyle(fontWeight: FontWeight.bold),
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
        '',
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Playlist kolaboratif berhasil dibuat!'),
          ),
        );
        setState(() => _currentIndex = 2);
        _libraryKey.currentState?.reload();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal bikin playlist')));
      }
    }
  }
}
