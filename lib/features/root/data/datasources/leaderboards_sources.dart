import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/data/models/leaderboards_models.dart';

class LeaderboardSources {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<LeaderboardsModels>> getLeaderboards() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('leaderboards').get();

      // Convert QuerySnapshot to List of LeaderboardsModels
      List<LeaderboardsModels> leaderboardsList = snapshot.docs.map((doc) {
        return LeaderboardsModels.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // Sort the leaderboardsList by the most badges
      leaderboardsList.sort((a, b) => (b.badges ?? 0).compareTo(a.badges ?? 0));

      // Assign the rank to each entry based on its index in the sorted list
      for (int i = 0; i < leaderboardsList.length; i++) {
        leaderboardsList[i] = leaderboardsList[i].copyWith(rank: i + 1);
      }

      return leaderboardsList;
    } catch (e) {
      // Handle any errors that occur during the data fetching process
      throw e.toString();
    }
  }

  Future<LeaderboardsModels> getLeaderboardsByUserId(
      List<LeaderboardsModels> leaderboardList) async {
    try {
      final userId = await AuthLocalStorage().getUserId();

      LeaderboardsModels userLeaderboards =
          leaderboardList.firstWhere((element) => element.userId == userId);

      return userLeaderboards;
    } catch (e) {
      // Handle any errors that occur during the data fetching process
      throw Exception("Error fetching leaderboards: $e");
    }
  }
}
