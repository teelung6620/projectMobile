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
  List<IngredientsId> ingredientsId;
  String? postImage;
  DateTime postTime;
  String userName;
  String? averageScore;
  int numOfScores;
  int totalCal;

  UserPost({
    required this.postId,
    required this.userId,
    required this.postName,
    required this.postDescription,
    required this.postTypes,
    required this.ingredientsId,
    required this.postImage,
    required this.postTime,
    required this.userName,
    required this.averageScore,
    required this.numOfScores,
    required this.totalCal,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        postId: json["post_id"],
        userId: json["user_id"],
        postName: json["post_name"],
        postDescription: json["post_description"],
        postTypes: json["post_types"],
        ingredientsId: List<IngredientsId>.from(
            json["ingredients_id"].map((x) => IngredientsId.fromJson(x))),
        postImage: json["post_image"],
        postTime: DateTime.parse(json["post_time"]),
        userName: json["user_name"],
        averageScore: json["average_score"],
        numOfScores: json["num_of_scores"],
        totalCal: json["totalCal"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "post_name": postName,
        "post_description": postDescription,
        "post_types": postTypes,
        "ingredients_id":
            List<dynamic>.from(ingredientsId.map((x) => x.toJson())),
        "post_image": postImage,
        "post_time": postTime.toIso8601String(),
        "user_name": userName,
        "average_score": averageScore,
        "num_of_scores": numOfScores,
        "totalCal": totalCal,
      };
}

class IngredientsId {
  String ingredientsName;
  int ingredientsUnits;
  int ingredientsCal;
  String ingredientsUnitsName;

  IngredientsId({
    required this.ingredientsName,
    required this.ingredientsUnits,
    required this.ingredientsCal,
    required this.ingredientsUnitsName,
  });

  factory IngredientsId.fromJson(Map<String, dynamic> json) => IngredientsId(
        ingredientsName: json["ingredients_name"],
        ingredientsUnits: json["ingredients_units"],
        ingredientsCal: json["ingredients_cal"],
        ingredientsUnitsName: json["ingredients_unitsName"],
      );

  Map<String, dynamic> toJson() => {
        "ingredients_name": ingredientsName,
        "ingredients_units": ingredientsUnits,
        "ingredients_cal": ingredientsCal,
        "ingredients_unitsName": ingredientsUnitsName,
      };
}
