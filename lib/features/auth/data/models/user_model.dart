import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String? userId,
      username,
      email,
      profilePhotoUrl,
      role,
      jabatan,
      nim,
      prodi;
  final String? notificationTokens;
  final DateTime? createdAt, updatedAt;
  final int? totalReports;

  const UserModel({
    this.notificationTokens,
    this.userId,
    this.username,
    this.email,
    this.role,
    this.jabatan,
    this.nim,
    this.prodi,
    this.createdAt,
    this.updatedAt,
    this.profilePhotoUrl,
    this.totalReports,
  });

  UserModel copyWith({
    String? userId,
    String? username,
    String? email,
    String? jabatan,
    String? nim,
    String? prodi,
    String? notificationTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? role,
    String? profilePhotoUrl,
    int? totalReports,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      jabatan: jabatan ?? this.jabatan,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      notificationTokens: notificationTokens ?? this.notificationTokens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      totalReports: totalReports ?? this.totalReports,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] as String?,
      username: data['username'] as String?,
      email: data['email'] as String?,
      role: data['role'] as String?,
      jabatan: data['jabatan'] as String?,
      nim: data['nim'] as String?,
      prodi: data['prodi'] as String?,
      notificationTokens: data['notificationTokens'] as String?,
      profilePhotoUrl: data['profilePhotoUrl'] as String?,
      totalReports: data['totalReports'] as int?,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdAt: (data['cratedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'username': username,
        'email': email,
        'role': role,
        'jabatan': jabatan,
        'nim': nim,
        'prodi': prodi,
        'notificationTokens': notificationTokens,
        'cratedAt': createdAt,
        'updatedAt': updatedAt,
        'profilePhotoUrl': profilePhotoUrl,
        'totalReports': totalReports,
      };

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      username.hashCode ^
      email.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      profilePhotoUrl.hashCode ^
      role.hashCode;
}
