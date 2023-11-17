import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    print(message);
  }

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await firebaseMessaging.getToken();
    if (kDebugMode) {
      print(token);
    }

    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessage.listen(handleMessage);

    FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  }

  Future<void> backgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");
    }
  }
}
