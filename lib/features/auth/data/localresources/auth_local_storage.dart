import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  Future<String> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('token', token);
    return token;
  }

  Future<String> saveUserId(String userId) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("userId", userId);

    return userId;
  }

  Future<bool> saveRole(bool role) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('role', role);
    return role;
  }

  Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token')!;
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
}
