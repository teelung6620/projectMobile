// To parse this JSON data, do
//
//     final commentsList = commentsListFromJson(jsonString);

import 'dart:convert';

List<CommentsList> commentsListFromJson(String str) => List<CommentsList>.from(
    json.decode(str).map((x) => CommentsList.fromJson(x)));

String commentsListToJson(List<CommentsList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentsList {
  int commentId;
  int postId;
  int userId;
  String commentLine;
  DateTime commentTime;
  String userName;
  String userImage;

  CommentsList({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.commentLine,
    required this.commentTime,
    required this.userName,
    required this.userImage,
  });

  factory CommentsList.fromJson(Map<String, dynamic> json) => CommentsList(
        commentId: json["comment_id"],
        postId: json["post_id"],
        userId: json["user_id"],
        commentLine: json["comment_line"],
        commentTime: DateTime.parse(json["comment_time"]),
        userName: json["user_name"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "post_id": postId,
        "user_id": userId,
        "comment_line": commentLine,
        "comment_time": commentTime.toIso8601String(),
        "user_name": userName,
        "user_image": userImage,
      };
}
