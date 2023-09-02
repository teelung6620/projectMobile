// To parse this JSON data, do
//
//     final registerResponseModel = registerResponseModelFromJson(jsonString);

import 'dart:convert';

RegisterResponseModel registerResponseModelFromJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) =>
    json.encode(data.toJson());

class RegisterResponseModel {
  Users? users;

  RegisterResponseModel({
    required this.users,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
          users: json["users"] != null ? Users.fromJson(json["users"]) : null);

  Map<String, dynamic> toJson() => {
        "users": users!.toJson(),
      };
}

class Users {
  String id;
  String userEmail;
  String userName;
  String userPassword;

  Users({
    required this.id,
    required this.userEmail,
    required this.userName,
    required this.userPassword,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        userEmail: json["user_email"],
        userName: json["user_name"],
        userPassword: json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_email": userEmail,
        "user_name": userName,
        "user_password": userPassword,
      };
}
