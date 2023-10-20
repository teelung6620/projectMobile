// To parse this JSON data, do
//
//     final reportList = reportListFromJson(jsonString);

import 'dart:convert';

List<ReportList> reportListFromJson(String str) =>
    List<ReportList>.from(json.decode(str).map((x) => ReportList.fromJson(x)));

String reportListToJson(List<ReportList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportList {
  int reportId;
  int postId;
  int userId;
  String userName;

  ReportList({
    required this.reportId,
    required this.postId,
    required this.userId,
    required this.userName,
  });

  factory ReportList.fromJson(Map<String, dynamic> json) => ReportList(
        reportId: json["report_id"],
        postId: json["post_id"],
        userId: json["user_id"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "report_id": reportId,
        "post_id": postId,
        "user_id": userId,
        "user_name": userName,
      };
}
