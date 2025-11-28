import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const _tokenKey = "auth_token";
  static const _userKey = "auth_user";
  static const _rawResponseKey = "auth_raw";

  Future<void> saveLogin(
    String token,
    Map<String, dynamic> user,
    Map raw,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
    await prefs.setString(_rawResponseKey, jsonEncode(raw));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  /// 🔥 NOVA FUNÇÃO DE LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_rawResponseKey);
  }

  /// (Opcional) manter clear() funcionando também
  Future<void> clear() async {
    await logout(); // reuso
  }
}
