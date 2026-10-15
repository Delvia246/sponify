import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/liked_service.dart';

class LikeButton extends StatefulWidget {
  final int songId;
  final Color color;
  final double size;

  const LikeButton({
    super.key,
    required this.songId,
    this.color = Colors.white,
    this.size = 22,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  bool _isLoading = true;
  int _userId = 1;

  final _likedService = LikedService();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id') ?? 1;
    await _checkLiked();
  }

  Future<void> _checkLiked() async {
    final liked = await _likedService.isLiked(_userId, widget.songId);
    if (!mounted) return;
    setState(() {
      _isLiked = liked;
      _isLoading = false;
    });
  }

  Future<void> _toggleLike() async {
    setState(() => _isLoading = true);

    bool result;
    if (_isLiked) {
      result = await _likedService.unlikeSong(_userId, widget.songId);
    } else {
      result = await _likedService.likeSong(_userId, widget.songId);
    }

    if (!mounted) return;
    if (result) {
      setState(() {
        _isLiked = !_isLiked;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLiked
                ? 'Ditambahkan ke Liked Songs'
                : 'Dihapus dari Liked Songs',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF1DB954),
        ),
      );
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(
          color: Color(0xFF1DB954),
          strokeWidth: 2,
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleLike,
      child: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? const Color(0xFF1DB954) : widget.color,
        size: widget.size,
      ),
    );
  }
}
