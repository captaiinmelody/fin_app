import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/firebase/auth/data/models/response/user_response_models.dart';

class LeaderboardSources {
  Future<List<UserResponseModels>> getUsers() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final QuerySnapshot snapshot = await firestore.collection("users").get();

      // Convert QuerySnapshot to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> userList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Sort the user list by status in descending order
      userList.sort((a, b) {
        final int statusA = a['status'] ?? 0;
        final int statusB = b['status'] ?? 0;
        return statusB.compareTo(statusA);
      });

      // Convert the sorted list back to UserResponseModels list
      final List<UserResponseModels> userResponseModel =
          userList.map((user) => UserResponseModels.fromMap(user)).toList();

      return userResponseModel;
    } catch (e) {
      throw e.toString();
    }
  }
}
