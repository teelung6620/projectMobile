import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_mobile/pages/home.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/api_endpoint.dart';

class RegisterationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body = {
        'user_name': nameController.text,
        'user_email': emailController.text.trim(),
        'user_password': passwordController.text
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'ok') {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          Get.off(LoginScreen());
        }
        if (json['error'] == 'Your email is already in use') {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: Text('Your email is already in use'),
                  contentPadding: EdgeInsets.all(20),
                );
              });
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
