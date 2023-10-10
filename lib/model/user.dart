// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  int userId;
  String userName;
  String userImage;
  String userEmail;
  String userPassword;

  User({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.userPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        userImage: json["user_image"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_image": userImage,
        "user_email": userEmail,
        "user_password": userPassword,
      };
}
