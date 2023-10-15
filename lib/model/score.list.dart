// To parse this JSON data, do
//
//     final scoreList = scoreListFromJson(jsonString);

import 'dart:convert';

List<ScoreList> scoreListFromJson(String str) =>
    List<ScoreList>.from(json.decode(str).map((x) => ScoreList.fromJson(x)));

String scoreListToJson(List<ScoreList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScoreList {
  int scoreId;
  int userId;
  int postId;
  int scoreNum;

  ScoreList({
    required this.scoreId,
    required this.userId,
    required this.postId,
    required this.scoreNum,
  });

  factory ScoreList.fromJson(Map<String, dynamic> json) => ScoreList(
        scoreId: json["score_id"],
        userId: json["user_id"],
        postId: json["post_id"],
        scoreNum: json["score_num"],
      );

  Map<String, dynamic> toJson() => {
        "score_id": scoreId,
        "user_id": userId,
        "post_id": postId,
        "score_num": scoreNum,
      };
}
