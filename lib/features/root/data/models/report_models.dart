import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class UserData {
  final String? userId, username, jabatan, profilePhotoUrl;

  const UserData({
    this.userId,
    this.username,
    this.jabatan,
    this.profilePhotoUrl,
  });

  factory UserData.fromMap(Map<String, dynamic> data) => UserData(
        userId: data['userId'] as String? ?? "",
        username: data['username'] as String? ?? "",
        jabatan: data['jabatan'] as String? ?? "",
        profilePhotoUrl: data['profilePhotoUrl'] as String? ?? "",
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'username': username,
        'jabatan': jabatan,
        'profilePhotoUrl': profilePhotoUrl,
      };

  factory UserData.fromJson(String data) {
    return UserData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

@immutable
class ReportsData {
  final String? campus, location, status;
  final String? reportsDescription, fixedDescription;

  const ReportsData({
    this.campus,
    this.location,
    this.status,
    this.reportsDescription,
    this.fixedDescription,
  });

  factory ReportsData.fromMap(Map<String, dynamic> data) => ReportsData(
        campus: data['campus'] as String? ?? "",
        location: data['location'] as String? ?? "",
        status: data['status'] as String? ?? "",
        reportsDescription: data['reportsDescription'] as String? ?? "",
        fixedDescription: data['fixedDescription'] as String? ?? "",
      );

  Map<String, dynamic> toMap() => {
        'reportsDescription': reportsDescription,
        'fixedDescription': fixedDescription,
        'campus': campus,
        'location': location,
        'status': status,
      };

  factory ReportsData.fromJson(String data) {
    return ReportsData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

@immutable
class MediaUrl {
  final List<String?>? imageUrls, fixedImageUrls;
  final String? videoUrl, fixedVideoUrl;

  const MediaUrl({
    this.imageUrls,
    this.videoUrl,
    this.fixedImageUrls,
    this.fixedVideoUrl,
  });

  factory MediaUrl.fromMap(Map<String, dynamic> data) => MediaUrl(
        imageUrls: data['imageUrls'] == null
            ? null
            : List<String>.from(data['imageUrls']),
        videoUrl: data['videoUrl'] as String? ?? '',
        fixedImageUrls: data['fixedImageUrls'] == null
            ? null
            : List<String>.from(data['fixedImageUrls']),
        fixedVideoUrl: data["fixedVideoUrl"] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'imageUrls': imageUrls,
        'videoUrl': videoUrl,
        'fixedImageUrls': fixedImageUrls,
        'fixedVideoUrl': fixedVideoUrl,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MediaUrl].
  factory MediaUrl.fromJson(String data) {
    return MediaUrl.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MediaUrl] to a JSON string.
  String toJson() => json.encode(toMap());

  MediaUrl copyWith(
      {List<String?>? imageUrls,
      videoUrl,
      List<String?>? fixedImageUrls,
      fixedVideoUrl}) {
    return MediaUrl(
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      fixedImageUrls: fixedImageUrls ?? this.fixedImageUrls,
      fixedVideoUrl: fixedVideoUrl ?? this.fixedVideoUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! MediaUrl) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => imageUrls.hashCode ^ videoUrl.hashCode;
}

@immutable
class ReportsModel {
  final String? reportsId;
  final UserData? userData;
  final ReportsData? reportsData;
  final MediaUrl? mediaUrl;
  final DateTime? datePublished, updatedAt;

  const ReportsModel({
    this.reportsId,
    this.userData,
    this.reportsData,
    this.mediaUrl,
    this.datePublished,
    this.updatedAt,
  });

  ReportsModel copyWith({
    String? reportsId,
    UserData? userData,
    ReportsData? reportsData,
    MediaUrl? mediaUrl,
    DateTime? datePublished,
    DateTime? updatedAt,
  }) {
    return ReportsModel(
      reportsId: reportsId ?? this.reportsId,
      userData: userData ?? this.userData,
      reportsData: reportsData ?? this.reportsData,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      datePublished: datePublished ?? this.datePublished,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ReportsModel.fromMap(Map<String, dynamic> data) {
    return ReportsModel(
      reportsId: data['reportsId'] as String? ?? "",
      userData:
          data['userData'] == null ? null : UserData.fromMap(data['userData']),
      reportsData: data['reportsData'] == null
          ? null
          : ReportsData.fromMap(data['reportsData']),
      mediaUrl:
          data['mediaUrl'] == null ? null : MediaUrl.fromMap(data['mediaUrl']),
      datePublished: data['datePublished'] == null
          ? null
          : (data['datePublished'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] == null
          ? null
          : (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'reportsId': reportsId,
        'userData': userData?.toMap(),
        'reportsData': reportsData?.toMap(),
        'mediaUrl': mediaUrl?.toMap(),
        'datePublished': datePublished,
        'updatedAt': updatedAt,
      };

  factory ReportsModel.fromJson(String data) {
    return ReportsModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
