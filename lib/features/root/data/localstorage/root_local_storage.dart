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

  Future<bool> saveRootPageShowCase(bool rootPageShowCase) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('rootPageShowCase', rootPageShowCase);
    return rootPageShowCase;
  }

  Future<bool> saveHomePageShowCase(bool homePageShowCase) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('homePageShowCase', homePageShowCase);
    return homePageShowCase;
  }

  Future<bool> saveMyReportsPageShowCase(bool myReportsPageShowCase) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('myReportsPageShowCase', myReportsPageShowCase);
    return myReportsPageShowCase;
  }

  Future<bool> saveLeaderboardsPageShowCase(
      bool leaderboardsPageShowCase) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('leaderboardsPageShowCase', leaderboardsPageShowCase);
    return leaderboardsPageShowCase;
  }

  Future<bool> reportsPageShowCase(bool reportsPageShowCase) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('reportsPageShowCase', reportsPageShowCase);
    return reportsPageShowCase;
  }

  Future<bool> adminReportsPageShowCase(bool adminReportsPageShowCase) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('adminReportsPageShowCase', adminReportsPageShowCase);
    return adminReportsPageShowCase;
  }

  Future<bool> myReportsPageSC(bool myReportsPageSC) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('myReportsPageSC', myReportsPageSC);
    return myReportsPageSC;
  }

  Future<bool> getmyReportsPageSC() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('myReportsPageSC') ?? false;
  }

  Future<bool> getRootPageShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('rootPageShowCase') ?? false;
  }

  Future<bool> getHomePageShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('homePageShowCase') ?? false;
  }

  Future<bool> getMyReportsPageShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('myReportsPageShowCase') ?? false;
  }

  Future<bool> getleaderboardsPageShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('leaderboardsPageShowCase') ?? false;
  }

  Future<bool> getReportsPageShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('reportsPageShowCase') ?? false;
  }

  Future<bool> getAdminReportsPageShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('adminReportsPageShowCase') ?? false;
  }
}
