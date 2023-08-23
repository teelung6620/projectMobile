// To parse this JSON data, do
//
//     final postTest = postTestFromJson(jsonString);

import 'dart:convert';

PostTest postTestFromJson(String str) => PostTest.fromJson(json.decode(str));

String postTestToJson(PostTest data) => json.encode(data.toJson());

class PostTest {
  int? postId;
  String? postName;

  PostTest({
    this.postId,
    this.postName,
  });

  factory PostTest.fromJson(Map<String, dynamic> json) => PostTest(
        postId: json["post_id"],
        postName: json["post_name"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "post_name": postName,
      };
}
