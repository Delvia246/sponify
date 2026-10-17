import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'library_tab.dart';
import 'premium_tab.dart';
import '../services/library_service.dart';
import '../services/session_service.dart';
import '../services/theme_service.dart';
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
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBody: true, // Agar konten bisa scroll di bawah navbar
      body: IndexedStack(
        index: _currentIndex == 4 ? 0 : _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MiniPlayer(),
            // Floating Bottom Navigation Bar (iOS Style)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF282828).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) async {
                    if (index == 4) {
                      await _showCreateSheet();
                      return;
                    }
                    setState(() => _currentIndex = index);
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: ThemeService().primaryColor, // Dinamis
                  unselectedItemColor: const Color(0xFFB3B3B3),
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  iconSize: 24,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                    BottomNavigationBarItem(icon: Icon(Icons.library_music_outlined), label: 'Library'),
                    BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_outlined), label: 'Premium'),
                    BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Create'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                            onTap: () {
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur playlist kolaboratif segera hadir'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          _sheetOption(
                            sheetContext,
                            icon: Icons.compare_arrows,
                            title: 'Blend',
                            subtitle: 'Satukan selera musik teman-temanmu dalam sebuah playlist',
                            onTap: () {
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur blend segera hadir'),
                                  duration: Duration(seconds: 1),
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
}