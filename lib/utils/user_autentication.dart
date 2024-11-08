import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAutentication {
  String _tokenKey = 'token';
  String _userIdKey = 'user_id';
  String _profileIdKey = 'profile_id';
  String _emailKey = 'email';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserAutentication();

  Future<void> setToken(String token) async {
    final prefs = await _prefs;
    prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey) ?? '';
  }

  Future<void> setUserId(int id) async {
    final prefs = await _prefs;
    prefs.setInt(_userIdKey, id);
  }

  Future<int?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getInt(_userIdKey) ?? -1;
  }

  Future<void> setProfileId(int profileId) async {
    final prefs = await _prefs;
    prefs.setInt(_profileIdKey, profileId);
  }

  Future<int?> getProfileId() async {
    final prefs = await _prefs;
    return prefs.getInt(_profileIdKey) ?? -1;
  }

  Future<bool> tokenExpired() async {
    final String? token = await getToken();
    if (token!.isNotEmpty) return JwtDecoder.isExpired(token);

    return true;
  }

  Future<void> setUserEmail(String email) async {
    final prefs = await _prefs;
    prefs.setString(_emailKey, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_emailKey);
  }
}
