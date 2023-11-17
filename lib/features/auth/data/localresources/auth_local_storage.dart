import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  Future<String> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('token', token);
    return token;
  }

  Future<String> saveFCMToken(String fcmToken) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('token', fcmToken);
    return fcmToken;
  }

  Future<String> saveUserId(String userId) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("userId", userId);

    return userId;
  }

  Future<String> saveRole(String role) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('role', role);
    return role;
  }

  Future<String> getRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("role")!;
  }

  Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token')!;
  }

  Future<String> getFCMToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('fcmToken')!;
  }

  Future<String> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("userId")!;
  }

  Future<bool> isTokenExist() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token') != null;
  }

  Future<bool> isRoleAdmin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('role')!;
  }

  Future<bool> removeToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove('token');
  }

  Future<bool> saveCheckShowcase(bool alreadyShowcasing) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('alreadyShowcasing', alreadyShowcasing);
    return alreadyShowcasing;
  }

  Future<bool> getCheckShowcase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('alreadyShowcasing')!;
  }
}
