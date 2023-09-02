import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  String userEmail;
  String userPassword;

  LoginRequestModel({
    required this.userEmail,
    required this.userPassword,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        userEmail: json["user_email"],
        userPassword: json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_password": userPassword,
      };
}
