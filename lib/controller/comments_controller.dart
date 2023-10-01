import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/pages/home.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/Ingredients.list.dart';
import '../utils/api_endpoint.dart';

class CommentsController extends GetxController {
  TextEditingController commentlineController = TextEditingController();
  late int user_id;
  late int post_id;

  // ...

  Future<void> commentsUser(int post_id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print(token);
      print("post_id: $post_id");
      // print(user_id);
      // print(user_id.runtimeType);
      // print(post_id.runtimeType);

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'];

      var headers = {'Content-Type': 'application/json'};
      // var request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse(
      //       ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.commentPost),
      // );

      // // เพิ่มข้อมูลอื่น ๆ ลงในคำขอ
      // request.fields['comment_line'] = commentlineController.text.trim();
      // request.fields['user_id'] = user_id;
      // request.fields['post_id'] = post_id.toString();

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.commentPost);
      Map body = {
        'comment_line': commentlineController.text.trim(),
        'user_id': user_id,
        'post_id': post_id,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      // ส่งคำขอ
      // final response = await request.send();

      if (response.statusCode == 200) {
        // final responseData = await response.stream.bytesToString();
        // final json = jsonDecode(responseData);

        commentlineController.clear();
      }
    } catch (e) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: Text('เกิดข้อผิดพลาด'),
            contentPadding: EdgeInsets.all(20),
            children: [Text(e.toString())],
          );
        },
      );
    }
  }
}
