import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/response/user_response_models.dart';

import 'package:flutter/foundation.dart';

class ProfileDataSources {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserResponseModels> fetchUserData() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    final userId = await AuthLocalStorage().getUserId();

    try {
      DocumentSnapshot documentSnapshot = await usersRef.doc(userId).get();

      if (documentSnapshot.exists) {
        // Convert the data from Firestore to a Map
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Create a UserResponseModels object from the data
        UserResponseModels userResponse = UserResponseModels.fromMap(data);

        if (kDebugMode) {
          print(userResponse.username);
        }
        // Return the user response
        return userResponse;
      } else {
        // Document not found, you can handle the error accordingly
        throw Exception('User with id $userId not found');
      }
    } catch (e) {
      // Error occurred during fetching or conversion
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
