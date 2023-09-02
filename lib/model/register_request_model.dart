// To parse this JSON data, do
//
//     final registerRequestModel = registerRequestModelFromJson(jsonString);

import 'dart:convert';

RegisterRequestModel registerRequestModelFromJson(String str) =>
    RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) =>
    json.encode(data.toJson());

class RegisterRequestModel {
  String userEmail;
  String userName;
  String userPassword;

  RegisterRequestModel({
    required this.userEmail,
    required this.userName,
    required this.userPassword,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      RegisterRequestModel(
        userEmail: json["user_email"],
        userName: json["user_name"],
        userPassword: json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_name": userName,
        "user_password": userPassword,
      };
}
