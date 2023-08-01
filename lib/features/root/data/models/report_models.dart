import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class MediaUrl {
  final String? imageUrl;
  final String? videoUrl;

  const MediaUrl({this.imageUrl, this.videoUrl});

  factory MediaUrl.fromMap(Map<String, dynamic> data) => MediaUrl(
        imageUrl: data['imageUrl'] as String? ?? '',
        videoUrl: data['videoUrl'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
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

  MediaUrl copyWith({
    String? imageUrl,
    String? videoUrl,
  }) {
    return MediaUrl(
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
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
  int get hashCode => imageUrl.hashCode ^ videoUrl.hashCode;
}

@immutable
class ReportsModels {
  final String? userId;
  final String? reportsId;
  final String? username;
  final String? profilePhotoUrl;
  final MediaUrl? mediaUrl;
  final String? description;
  final DateTime? datePublished;
  final int? totalLikes;
  final int? totalComments;
  // final GeoPoint? location;
  final String? kampus;
  final String? detailLokasi;
  final int? status;

  const ReportsModels({
    this.userId,
    this.username,
    this.profilePhotoUrl,
    this.mediaUrl,
    this.reportsId,
    this.description,
    this.datePublished,
    this.totalLikes,
    this.totalComments,
    // this.location,
    this.kampus,
    this.detailLokasi,
    this.status,
  });

  ReportsModels copyWith({
    String? userId,
    String? username,
    String? reportsId,
    String? profilePhotoUrl,
    MediaUrl? mediaUrl,
    String? description,
    DateTime? datePublished,
    int? totalLikes,
    int? totalComments,
    // GeoPoint? location,
    String? kampus,
    String? detailLokasi,
    int? status,
  }) {
    return ReportsModels(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        reportsId: reportsId ?? this.reportsId,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        description: description ?? this.description,
        datePublished: datePublished ?? this.datePublished,
        totalLikes: totalLikes ?? this.totalLikes,
        totalComments: totalComments ?? this.totalComments,
        // location: location ?? this.location,
        kampus: kampus ?? this.kampus,
        detailLokasi: detailLokasi ?? this.detailLokasi,
        status: status ?? this.status);
  }

  factory ReportsModels.fromMap(Map<String, dynamic> data) {
    return ReportsModels(
      userId: data['userId'],
      username: data['username'],
      reportsId: data['reportsId'],
      mediaUrl:
          data['mediaUrl'] == null ? null : MediaUrl.fromMap(data['mediaUrl']),
      profilePhotoUrl: data['profilePhotoUrl'],
      description: data['description'],
      datePublished: data['datePublished'] == null
          ? null
          : (data['datePublished'] as Timestamp).toDate(),
      totalLikes: data['totalLikes'] ?? 0,
      totalComments: data['totalComments'] ?? 0,
      kampus: data['kampus'] ?? '',
      detailLokasi: data['detailLokasi'] ?? '',
      status: data['status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'username': username,
        'reportsId': reportsId,
        'mediaUrl': mediaUrl?.toMap(),
        'profilePhotoUrl': profilePhotoUrl,
        'description': description,
        'datePublished': datePublished,
        'totalLikes': totalLikes,
        'totalComments': totalComments,
        // 'location': location,
        'kampus': kampus,
        'detailLokasi': detailLokasi,
        'status': status,
      };

  factory ReportsModels.fromJson(String data) {
    return ReportsModels.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ReportsModels) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      reportsId.hashCode ^
      description.hashCode ^
      datePublished.hashCode ^
      totalLikes.hashCode ^
      totalComments.hashCode;
}
