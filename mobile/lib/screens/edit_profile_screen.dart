import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  bool _isSaving = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SessionService.getUser();
    if (user != null) {
      _user = user;
      _nameController.text = user.username;
    }
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    setState(() => _isSaving = true);

    final result = await AuthService().updateUsername(
      _user!.id,
      _nameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result['success'] == true) {
      // Update Session Lokal agar nama di menu lain berubah
      await SessionService.saveUser(
        User(
          id: _user!.id,
          username: _nameController.text.trim(),
          email: _user!.email,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Color(0xFF1DB954),
        ),
      );
      Navigator.pop(
        context,
        true,
      ); // Kirim 'true' agar ProfileScreen me-refresh
    } else {
      // Tampilkan pesan error asli (misal: Username sudah digunakan)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal memperbarui profil'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit profil',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  )
                : const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF282828),
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Text(
                  'Nama',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
