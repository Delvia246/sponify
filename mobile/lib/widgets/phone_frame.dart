import 'package:flutter/material.dart';

/// phoneWrap() sekarang hanya return child — frame sudah di-handle main.dart.
/// Semua pemanggilan phoneWrap(...) di file lain otomatis jadi bypass.
Widget phoneWrap(Widget screen) => screen;

/// Class PhoneFrame tetap ada biar tidak error kalau masih dipakai di tempat lain.
class PhoneFrame extends StatelessWidget {
  final Widget child;
  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
