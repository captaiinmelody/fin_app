import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class PayloadData {
  final String? reportsId, routerName, userId;

  const PayloadData({this.reportsId, this.routerName, this.userId});

  factory PayloadData.fromMap(Map<String, dynamic> data) => PayloadData(
        reportsId: data['reportsId'] as String?,
        routerName: data['routerName'] as String?,
        userId: data['userId'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'reportsId': reportsId,
        'routerName': routerName,
        'userId': userId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PayloadData].
  factory PayloadData.fromJson(String data) {
    return PayloadData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PayloadData] to a JSON string.
  String toJson() => json.encode(toMap());

  PayloadData copyWith({
    String? reportsId,
    String? routerName,
    String? userId,
  }) {
    return PayloadData(
      reportsId: reportsId ?? this.reportsId,
      routerName: routerName ?? this.routerName,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PayloadData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => reportsId.hashCode ^ routerName.hashCode;
}

@immutable
class NotificationData {
  final String? title;
  final String? body;
  final String? sound;
  final String? color;
  final bool? alert;

  const NotificationData({
    this.title,
    this.body,
    this.sound,
    this.color,
    this.alert,
  });

  factory NotificationData.fromMap(Map<String, dynamic> data) =>
      NotificationData(
        title: data['title'] as String?,
        body: data['body'] as String?,
        sound: data['sound'] as String?,
        color: data['color'] as String?,
        alert: data['alert'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'sound': sound,
        'color': color,
        'alert': alert,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NotificationData].
  factory NotificationData.fromJson(String data) {
    return NotificationData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NotificationData] to a JSON string.
  String toJson() => json.encode(toMap());

  NotificationData copyWith({
    String? title,
    String? body,
    String? sound,
    String? color,
    bool? alert,
  }) {
    return NotificationData(
      title: title ?? this.title,
      body: body ?? this.body,
      sound: sound ?? this.sound,
      color: color ?? this.color,
      alert: alert ?? this.alert,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! NotificationData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      title.hashCode ^
      body.hashCode ^
      sound.hashCode ^
      color.hashCode ^
      alert.hashCode;
}

@immutable
class NotificationModels {
  final String? to;
  final String? priority;
  final PayloadData? data;
  final NotificationData? notification;
  final DateTime? createdAt;

  const NotificationModels({
    this.to,
    this.priority,
    this.data,
    this.notification,
    this.createdAt,
  });

  factory NotificationModels.fromMap(Map<String, dynamic> data) {
    return NotificationModels(
      to: data['to'] as String?,
      priority: data['priority'] as String?,
      data: data['data'] == null
          ? null
          : PayloadData.fromMap(data['data'] as Map<String, dynamic>),
      notification: data['notification'] == null
          ? null
          : NotificationData.fromMap(
              data['notification'] as Map<String, dynamic>),
      createdAt: data['createdAt'] == null
          ? null
          : (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'to': to,
      'priority': priority,
      'data': data?.toMap(),
      'notification': notification?.toMap(),
    };

    // Only add createdAt if it's not null
    if (createdAt != null) {
      map['createdAt'] = createdAt;
    }

    return map;
  }

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NotificationModels].
  factory NotificationModels.fromJson(String data) {
    return NotificationModels.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NotificationModels] to a JSON string.
  String toJson() => json.encode(toMap());

  NotificationModels copyWith({
    String? to,
    String? priority,
    PayloadData? data,
    NotificationData? notification,
    DateTime? createdAt,
  }) {
    return NotificationModels(
      to: to ?? this.to,
      priority: priority ?? this.priority,
      data: data ?? this.data,
      notification: notification ?? this.notification,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! NotificationModels) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => to.hashCode ^ priority.hashCode ^ notification.hashCode;
}
