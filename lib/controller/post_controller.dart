import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/pages/home.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/api_endpoint.dart';

class PostController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController idController = TextEditingController();

  late String user_id;

  Future<void> postMenuUser() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.postMenu);
      Map body = {
        'post_name': nameController.text,
        'post_description': descriptionController.text.trim(),
        'post_types': typeController.text,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'ok') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("token");
          print(token);

          Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);

          user_id = jwtDecodedToken['user_id'];

          nameController.clear();
          descriptionController.clear();
          typeController.clear();

          Get.off(HomePage(
            token: token,
          ));
        }
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}
