import 'package:shared_preferences/shared_preferences.dart';

class PrefHelpers {
  // ignore: constant_identifier_names
  static const String _token_key = 'auth_token';
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_token_key, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    // prefs.getString(_token_key);
    return prefs.getString(_token_key);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(_token_key);
  }
}
