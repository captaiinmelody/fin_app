import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class UserResponseModels {
  final String? userId;
  final String? username;
  final String? email;
  final String? bio;
  final DateTime? birthDate;
  final DateTime? cratedAt;
  final DateTime? updatedAt;
  final bool? isAdmin;
  final String? profilePhotoUrl;
  final int? badges;

  const UserResponseModels({
    this.userId,
    this.username,
    this.email,
    this.bio,
    this.birthDate,
    this.cratedAt,
    this.updatedAt,
    this.isAdmin,
    this.profilePhotoUrl,
    this.badges,
  });

  factory UserResponseModels.fromMap(Map<String, dynamic> data) {
    return UserResponseModels(
      userId: data['userId'] as String?,
      username: data['username'] as String?,
      email: data['email'] as String?,
      bio: data['bio'] as String?,
      birthDate: data['birthDate'] as DateTime?,
      cratedAt: data['cratedAt'] as DateTime?,
      updatedAt: data['updatedAt'] as DateTime?,
      isAdmin: data['isAdmin'] as bool?,
      profilePhotoUrl: data['profilePhotoUrl'] as String?,
      badges: data['badges'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'username': username,
        'email': email,
        'bio': bio,
        'birthDate': birthDate,
        'cratedAt': cratedAt,
        'updatedAt': updatedAt,
        'isAdmin': isAdmin,
        'profilePhotoUrl': profilePhotoUrl,
        'badges': badges,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserResponseModels].
  factory UserResponseModels.fromJson(String data) {
    return UserResponseModels.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserResponseModels] to a JSON string.
  String toJson() => json.encode(toMap());

  UserResponseModels copyWith({
    String? userId,
    String? username,
    String? email,
    String? bio,
    DateTime? birthDate,
    DateTime? cratedAt,
    DateTime? updatedAt,
    bool? isAdmin,
    String? profilePhotoUrl,
    int? badges,
  }) {
    return UserResponseModels(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      cratedAt: cratedAt ?? this.cratedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAdmin: isAdmin ?? this.isAdmin,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      badges: badges ?? this.badges,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserResponseModels) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      username.hashCode ^
      email.hashCode ^
      bio.hashCode ^
      birthDate.hashCode ^
      cratedAt.hashCode ^
      updatedAt.hashCode ^
      profilePhotoUrl.hashCode ^
      isAdmin.hashCode;
}
