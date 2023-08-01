import 'package:shared_preferences/shared_preferences.dart';

class RootLocalStorgae {
  Future<bool> saveIsAlreadyLiking(bool isAlreadyLiking) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("isAlreadyLiking", isAlreadyLiking);

    return isAlreadyLiking;
  }

  Future<bool> getIsAlreadyLiking() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isAlreadyLiking')!;
  }

  Future<String> saveReportsId(String reportsId) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("reportsId", reportsId);

    return reportsId;
  }

  Future<String> getReportsId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("reportsId")!;
  }
}
