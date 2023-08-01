import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/request/user_models.dart';
import 'package:fin_app/features/auth/data/models/response/user_response_models.dart';
import 'package:fin_app/features/root/data/datasources/profile_sources.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ProfileDataSources profileDataSources = ProfileDataSources();

  Future<UserModel?> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot userSnapshot =
            await firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          final userResponseModels = UserResponseModels.fromMap(
              userSnapshot.data() as Map<String, dynamic>);
          final token = await user.getIdToken();
          final bool isAdmin = userResponseModels.isAdmin ?? false;

          await AuthLocalStorage().saveRole(isAdmin);

          print(isAdmin);

          return UserModel(user.uid, email, token);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(
            message: 'User not found. Please check your email and try again.');
      } else if (e.code == 'wrong-password') {
        throw AuthException(
            message:
                'Wrong password. Please check your password and try again.');
      } else {
        throw AuthException(
            message:
                'Login failed. Please try again.'); // For other Firebase exceptions
      }
    } catch (e) {
      throw AuthException();
    }

    throw AuthException();
  }

  Future<bool> register(
    String email,
    String password,
    UserResponseModels userResponseModels,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      final userId = user!.uid;

      final usernameExists =
          await checkUsernameExists(userResponseModels.username!);

      if (!usernameExists) {
        // Username already exists, so return an error message
        final newUserResponseModels = userResponseModels.copyWith(
          userId: userId,
          badges: 0,
          totalReports: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAdmin: false,
          bio: '',
          profilePhotoUrl:
              'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
        );

        await firestore
            .collection('users')
            .doc(userId)
            .set(newUserResponseModels.toMap());
      } else {
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException(
            message:
                'Email already in use. Please change your username and try again.');
      } else {
        throw AuthException(
            message:
                'Register failed. Please try again.'); // For other Firebase exceptions
      }
    } catch (e) {
      log('Error registering user: $e');
      throw e.toString();
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log('Error checking username existence: $e');
      throw e.toString();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log('Error sending password reset email: $e');
    }
  }
}
