import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/login_model.dart';
import 'package:fin_app/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tabler/tabler.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseMessaging firebaseMessaging;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseMessaging? firebaseMessaging,
  })  : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance,
        firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  Stream<User?> get user => auth.authStateChanges();

  Future<LoginModel?> login(String email, String password) async {
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
          final userModels =
              UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
          final token = await user.getIdToken();
          final String role = userModels.role ?? "reporter";

          String updatedNotificationTokens =
              userModels.notificationTokens ?? "";

          final notificationToken = await firebaseMessaging.getToken();

          updatedNotificationTokens = notificationToken!;

          firestore
              .collection('users')
              .doc(user.uid)
              .update({"notificationToken": updatedNotificationTokens});

          await AuthLocalStorage().saveRole(role);
          await AuthLocalStorage().saveFCMToken(notificationToken);
          await AuthLocalStorage().saveCheckShowcase(false);

          return LoginModel(user.uid, email, token);
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw AuthException(message: e.message);
    } catch (e) {
      print(e);
      throw AuthException(message: e.toString());
    }

    throw AuthException();
  }

  Future<bool> register(
      {String? email, String? password, UserModel? userModels}) async {
    try {
      if (email == null || password == null) {
        return false;
      }
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      final userId = user!.uid;

      final newUserResponseModels = userModels!.copyWith(
        userId: userId,
        totalReports: 0,
        role: "reporter",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        profilePhotoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
      );

      try {
        await firestore
            .collection('users')
            .doc(userId)
            .set(newUserResponseModels.toMap());
      } catch (e) {
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw e.toString();
    }
  }

  void loginDebug(LoginModel user) {
    if (kDebugMode) {
      final table = Tabler(
        header: ['Nama Data', 'Response Data'],
        data: [
          ['User ID', user.id],
          ['Email', user.email],
          ['Token', user.token],
          ['Role', user.role],
          ['Notification Token', user.notificationToken],
        ],
      );

      print('Login berhasil dengan data yang didapat:');
      print(table);
    }
  }

  void registerDebug(UserModel userModels) {
    if (kDebugMode) {
      final table = Tabler(
        header: ['Nama Data', 'Response Data'],
        data: [
          ['User ID', userModels.userId],
          ['Username', userModels.username],
          ['Email', userModels.email],
          ['Role', userModels.role],
          ['Jabatan', userModels.jabatan],
          ['NIM', userModels.nim],
          ['Total Reports', userModels.totalReports],
          ['Created At', userModels.createdAt.toString()],
          ['Updated At', userModels.updatedAt.toString()],
          ['Profile Photo URL', userModels.profilePhotoUrl],
        ],
      );

      print('Register berhasil dengan data yang didapat:');
      print(table);
    }
  }
}
