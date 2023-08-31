import 'dart:convert';

List<UserPost> userPostFromJson(String str) =>
    List<UserPost>.from(json.decode(str).map((x) => UserPost.fromJson(x)));

String userPostToJson(List<UserPost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPost {
  int postId;
  String postName;
  String postTypes;

  UserPost({
    required this.postId,
    required this.postName,
    required this.postTypes,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        postId: json["post_id"],
        postName: json["post_name"],
        postTypes: json["post_types"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "post_name": postName,
        "post_types": postTypes,
      };
}

class PostImage {
  String type;
  List<dynamic> data;

  PostImage({
    required this.type,
    required this.data,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) => PostImage(
        type: json["type"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
