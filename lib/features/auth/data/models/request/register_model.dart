import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// {
//   "name": "Nicolas",
//   "email": "nico@gmail.com",
//   "password": "1234",
//   "avatar": "https://api.lorem.space/image/face?w=640&h=480&r=867"
// }

class RegisterModel {
  final String? name;
  final String? email;
  final String? password;
  final String? confPassword;
  final String? avatar;

  RegisterModel({
    this.name,
    this.email,
    this.password,
    this.confPassword,
    this.avatar = 'https://api.lorem.space/image/face?w=640&h=480&r=867',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      avatar: map['avatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterModel.fromJson(String source) =>
      RegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
