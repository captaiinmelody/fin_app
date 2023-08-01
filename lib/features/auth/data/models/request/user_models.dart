import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String token;

  UserModel(this.id, this.email, this.token);

  factory UserModel.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return UserModel(map['id'], map['email'], map['token']);
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(map['id'], map['email'], map['token']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }
}
