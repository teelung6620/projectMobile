// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String id;
  String userEmail;
  String userName;
  String userPassword;
  String token;

  LoginResponseModel({
    required this.id,
    required this.userEmail,
    required this.userName,
    required this.userPassword,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        id: json["id"],
        userEmail: json["user_email"],
        userName: json["user_name"],
        userPassword: json["user_password"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_email": userEmail,
        "user_name": userName,
        "user_password": userPassword,
        "token": token,
      };
}
