import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/data/models/notification_models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class NotificationSources {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: "default_group",
          channelKey: "1",
          channelName: "channelName",
          channelDescription: "channelDescription",
          defaultColor: AppColors.primaryColor,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: "default_group",
          channelGroupName: "channelGroupName",
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (!value) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      messageHandler(message);
    });
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      messageHandler(initialMessage);
    }
    FirebaseMessaging.onBackgroundMessage(messageHandler);
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayMethod(
      ReceivedNotification receivedNotification) async {
    print('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissReceiveMethod(
      ReceivedNotification receivedNotification) async {
    print('onDismissReceiveMethod');
  }

  static Future<void> onActionReceiveMethod(
      ReceivedNotification receivedNotification) async {
    final payload = receivedNotification.payload;
    if (payload!.containsKey('reportsId')) {
      // final reportsId = payload['reportsId'];
      // MyRouter.router.goNamed(MyRouterConstant.notificationDetailRouterName,
      //     pathParameters: {'reportsId': reportsId!});
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? summary,
    Map<String, String>? payload,
    ActionType actionType = ActionType.Default,
    NotificationLayout notificationLayout = NotificationLayout.Default,
    NotificationCategory? category,
    String? bigPicture,
    List<NotificationActionButton>? actionButton,
    bool scheduled = false,
    int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: "1",
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButton,
    );
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    await showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
    if (kDebugMode) {
      print("Background Message Received:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");
    }
  }

  Future<void> messageHandler(RemoteMessage message) async {
    final title = message.notification?.title;
    final body = message.notification?.body;
    // final payload = message.data;

    await showNotification(
      title: title,
      body: body,
    );

    // Check if the app is in the foreground
    if (kDebugMode) {
      print("Foreground Message Received:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");
    }
  }

  Future<void> sendNotification(
    String notificationToken,
    String title,
    String body,
    String reportsId,
    String userId,
  ) async {
    NotificationModels notificationModels = NotificationModels(
        to: notificationToken,
        priority: "high",
        data: PayloadData(reportsId: reportsId, userId: userId),
        notification: NotificationData(
            alert: true,
            title: title,
            body: body,
            sound: "default",
            color: "#990000"));
    final notificationHistory =
        notificationModels.copyWith(createdAt: DateTime.now());
    final notificationId = const Uuid().v1();

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: notificationModels.toJson(),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAzpAZGj4:APA91bGz88OREr91GYfY7AAwUjzC-_7QdOH2_IPwOgvRZql6a6B0vv8EO2KD67dnoh8DLw8EtZOszdPWeRgVLX2dFcApwQw2Xhq7L4DS0UShjEOFdpB0LjXWu1pm97OBnfXy8uBSrJZU'
        });

    await firestore
        .collection('notification')
        .doc(notificationId)
        .set(notificationHistory.toMap());
  }

  Future<List<NotificationModels>> getNotificationHistory(String userId) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('notification')
          .where('data.userId', isEqualTo: userId)
          .get();

      final List<NotificationModels> notificationModels =
          snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NotificationModels.fromMap(data);
      }).toList();

      notificationModels.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      return notificationModels;
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to fetch NotificationModels");
    }
  }
}
