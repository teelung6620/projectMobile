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
  UserType userType;
  String userImage;
  String userEmail;
  String userPassword;
  int banned;

  User({
    required this.userId,
    required this.userName,
    required this.userType,
    required this.userImage,
    required this.userEmail,
    required this.userPassword,
    required this.banned,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        userType: userTypeValues.map[json["user_type"]]!,
        userImage: json["user_image"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
        banned: json["banned"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_type": userTypeValues.reverse[userType],
        "user_image": userImage,
        "user_email": userEmail,
        "user_password": userPassword,
        "banned": banned,
      };
}

enum UserType { ADMIN, USER }

final userTypeValues =
    EnumValues({"admin": UserType.ADMIN, "user": UserType.USER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
