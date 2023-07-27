import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/firebase/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/firebase/auth/data/models/request/user_models.dart';
import 'package:fin_app/features/firebase/auth/data/models/response/user_response_models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final token = await user.getIdToken();
        return UserModel(user.uid, user.email!, token);
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

  Future<String?> register(
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

      final newUserResponseModels = userResponseModels.copyWith(
        userId: userId,
        badges: 0,
        totalReports: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAdmin: false,
        bio: '',
        birthDate: null,
        profilePhotoUrl: null,
      );

      await firestore
          .collection('users')
          .doc(userId)
          .set(newUserResponseModels.toMap());

      return "Registration account success! you casn now log in";
    } catch (e) {
      log('Error registering user: $e');
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
