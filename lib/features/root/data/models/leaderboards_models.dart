import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class LeaderboardsModels {
  final String? leaderboardsId;
  final String? userId;
  final String? profilePhotoUrl;
  final String? username;
  final int? totalReports;
  final int? badges;
  final int? rank;

  const LeaderboardsModels({
    this.leaderboardsId,
    this.userId,
    this.profilePhotoUrl,
    this.username,
    this.totalReports,
    this.badges,
    this.rank,
  });

  @override
  String toString() {
    return 'LeaderboardsModels(leaderboardsId: $leaderboardsId, userId: $userId, profilePhotoUrl: $profilePhotoUrl, username: $username, badges: $badges, totalReports: $totalReports, rank: $rank)';
  }

  factory LeaderboardsModels.fromMap(Map<String, dynamic> data) {
    return LeaderboardsModels(
      leaderboardsId: data['leaderboardsId'] as String? ?? "",
      userId: data['userId'] as String? ?? "",
      profilePhotoUrl: data['profilePhotoUrl'] as String? ?? "",
      username: data['username'] as String? ?? "",
      totalReports: data['totalReports'] as int? ?? 0,
      badges: data['badges'] as int? ?? 0,
      rank: data['rank'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'leaderboardsId': leaderboardsId ?? "",
        'userId': userId ?? "",
        'profilePhotoUrl': profilePhotoUrl ?? "",
        'username': username ?? "",
        'totalReports': totalReports ?? "",
        'badges': badges ?? 0,
        'rank': rank ?? 0,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LeaderboardsModels].
  factory LeaderboardsModels.fromJson(String data) {
    return LeaderboardsModels.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LeaderboardsModels] to a JSON string.
  String toJson() => json.encode(toMap());

  LeaderboardsModels copyWith({
    String? leaderboardsId,
    String? userId,
    String? profilePhotoUrl,
    String? username,
    int? totalReports,
    int? badges,
    int? rank,
  }) {
    return LeaderboardsModels(
      leaderboardsId: leaderboardsId ?? this.leaderboardsId,
      userId: userId ?? this.userId,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      username: username ?? this.username,
      totalReports: totalReports ?? this.totalReports,
      badges: badges ?? this.badges,
      rank: rank ?? this.badges,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LeaderboardsModels) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      leaderboardsId.hashCode ^
      userId.hashCode ^
      profilePhotoUrl.hashCode ^
      username.hashCode ^
      badges.hashCode;
}
