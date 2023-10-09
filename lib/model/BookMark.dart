// To parse this JSON data, do
//
//     final bookMark = bookMarkFromJson(jsonString);

import 'dart:convert';

List<BookMark> bookMarkFromJson(String str) =>
    List<BookMark>.from(json.decode(str).map((x) => BookMark.fromJson(x)));

String bookMarkToJson(List<BookMark> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookMark {
  int bookmarkId;
  int userId;
  int postId;

  BookMark({
    required this.bookmarkId,
    required this.userId,
    required this.postId,
  });

  factory BookMark.fromJson(Map<String, dynamic> json) => BookMark(
        bookmarkId: json["bookmark_id"],
        userId: json["user_id"],
        postId: json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "bookmark_id": bookmarkId,
        "user_id": userId,
        "post_id": postId,
      };
}
