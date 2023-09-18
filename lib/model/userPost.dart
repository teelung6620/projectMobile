// To parse this JSON data, do
//
//     final userPost = userPostFromJson(jsonString);

import 'dart:convert';

List<UserPost> userPostFromJson(String str) =>
    List<UserPost>.from(json.decode(str).map((x) => UserPost.fromJson(x)));

String userPostToJson(List<UserPost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPost {
  int postId;
  int userId;
  String postName;
  String postDescription;
  String postTypes;
  String postImage;
  DateTime postTime;
  String userName;
  String userImage;
  String userEmail;
  String userPassword;

  UserPost({
    required this.postId,
    required this.userId,
    required this.postName,
    required this.postDescription,
    required this.postTypes,
    required this.postImage,
    required this.postTime,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.userPassword,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        postId: json["post_id"],
        userId: json["user_id"],
        postName: json["post_name"],
        postDescription: json["post_description"],
        postTypes: json["post_types"],
        postImage: json["post_image"],
        postTime: DateTime.parse(json["post_time"]),
        userName: json["user_name"],
        userImage: json["user_image"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "post_name": postName,
        "post_description": postDescription,
        "post_types": postTypes,
        "post_image": postImage,
        "post_time": postTime.toIso8601String(),
        "user_name": userName,
        "user_image": userImage,
        "user_email": userEmail,
        "user_password": userPassword,
      };
}
