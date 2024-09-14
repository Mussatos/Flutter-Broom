import 'package:shared_preferences/shared_preferences.dart';

class UserAutentication {
String _tokenKey = 'token';
String _userIdKey = 'user_id';
String _profileIdKey = 'profile_id';
final Future<SharedPreferences> _prefs =  SharedPreferences.getInstance();

  UserAutentication();

  Future<void> setToken(String token) async {
    final prefs = await _prefs;
    prefs.setString(_tokenKey,token);
  }

  Future<String?> getToken() async{
    final prefs = await _prefs;
    return prefs.getString(_tokenKey) ?? '';
  }

   Future<void> setUserId(int id) async {
    final prefs = await _prefs;
    prefs.setInt(_userIdKey, id);
  }

  Future<int?> getUserId() async{
    final prefs = await _prefs;
    return prefs.getInt(_userIdKey) ?? -1;
  }

   Future<void> setProfileId(int profileId) async {
    final prefs = await _prefs;
    prefs.setInt(_profileIdKey, profileId);
  }

  Future<int?> getProfileId() async{
    final prefs = await _prefs;
    return prefs.getInt(_profileIdKey) ?? -1;
  }
  
}
