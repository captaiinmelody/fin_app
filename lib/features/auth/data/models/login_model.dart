import 'dart:convert';

class LoginModel {
  final String id, email, token;
  final String? role, notificationToken;

  LoginModel(
    this.id,
    this.email,
    this.token, {
    this.role,
    this.notificationToken,
  });

  factory LoginModel.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return LoginModel(
      map['id'],
      map['email'],
      map['token'],
      role: map['role'],
      notificationToken: map['notificationToken'],
    );
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      map['id'],
      map['email'],
      map['token'],
      role: map['role'],
      notificationToken: map['notificationToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
      'role': role,
      'notificationToken': notificationToken,
    };
  }
}
