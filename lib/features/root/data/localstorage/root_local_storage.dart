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
}
