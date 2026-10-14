import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SessionService {
  static const _keyId = 'user_id';
  static const _keyUsername = 'user_username';
  static const _keyEmail = 'user_email';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyId, user.id);
    await prefs.setString(_keyUsername, user.username);
    await prefs.setString(_keyEmail, user.email);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_keyId);
    final username = prefs.getString(_keyUsername);
    final email = prefs.getString(_keyEmail);

    if (id == null || username == null || email == null) return null;
    return User(id: id, username: username, email: email);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
  }
}