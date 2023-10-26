import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:http/http.dart' as http;
import 'package:project_mobile/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/ADMINpages/adminPage.dart';
import '../pages/homeTest.dart';
import '../utils/api_endpoint.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController OldPassController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late int user_id;
  late int post_id;
  File? userImage;

  Future<void> loginWithEmail() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
      Map body = {
        'user_email': emailController.text.trim(),
        'user_password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'verify') {
          Get.snackbar(
            'Verify',
            'verify your email',
            snackPosition: SnackPosition.TOP,
          );
        }
        if (json['status'] == 'ok_user') {
          var token = json['token'];

          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);

          emailController.clear();
          passwordController.clear();
          Get.off(HomePage(
            token: token,
          ));
        } else if (json['status'] == 'ok_admin') {
          var token = json['token'];

          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);

          emailController.clear();
          passwordController.clear();
          Get.off(AdminPage(
            token: token,
          ));
        } else if (json['status'] == 'error') {
          throw jsonDecode(response.body)['message'];
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }

  // Future<void> patchUserData({
  //   required String token,
  //   String? user_name,
  //   String? user_email,
  //   String? user_image,
  // }) async {
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   try {
  //     var url = Uri.parse(
  //         ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
  //     Map<String, dynamic> body = {};

  //     if (user_name != null) {
  //       body['user_name'] = user_name;
  //       // Update the nameController value
  //       nameController.text = user_name;
  //     }
  //     if (user_email != null) {
  //       body['user_email'] = user_email;
  //       // Update the emailController value
  //       emailController.text = user_email;
  //     }
  //     if (user_image != null) {
  //       body['user_image'] = user_image;
  //     }

  //     http.Response response =
  //         await http.patch(url, body: jsonEncode(body), headers: headers);

  //     if (response.statusCode == 200) {
  //       // User data updated successfully
  //       // You can perform any additional actions if needed
  //     }
  //   } catch (error) {
  //     // Handle errors as needed
  //   }
  // }

  Future<void> patchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print(token);

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'];

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.UpdateUser);

      var request = http.MultipartRequest('PATCH', url);

      // เพิ่มข้อมูลผู้ใช้ที่ต้องการอัปเดต
      request.fields['user_id'] = user_id.toString();
      request.fields['user_name'] = nameController.text;
      // request.fields['user_email'] = emailController.text;
      request.fields['user_password'] = passwordController.text;
      // request.fields['old_password'] = OldPassController.text;
      // เพิ่มรูปภาพเข้าไป

      // if (imagePath != null) {
      //   request.files.add(await http.MultipartFile.fromPath(
      //     'user_image', // ชื่อของ field สำหรับรูปภาพในร้องขอ
      //     imagePath, // ไฟล์รูปภาพ
      //     contentType: MediaType('image', 'jpeg/png/jpg'),
      //   ));
      //   //print(imagePath);
      // }

      // ใส่ Token เข้าไปใน header เพื่อทำการยืนยันตัวตน
      request.headers['Authorization'] = 'Bearer $token';

      // ส่งคำขอ
      var response = await request.send();
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

  // Future<void> patchUserData() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString("token");
  //     print(token);
  //     //print("post_id: $post_id");

  //     Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
  //     user_id = jwtDecodedToken['user_id'];

  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };

  //     var url = Uri.parse(ApiEndPoints.baseUrl +
  //         ApiEndPoints
  //             .authEndpoints.loginEmail); // ปรับเปลี่ยน URL ตามความเหมาะสม

  //     Map body = {
  //       'user_id': user_id,
  //       'user_name': nameController.text,
  //       'user_email': emailController.text,
  //       'user_password': passwordController.text,
  //     };
  //     http.Response response =
  //         await http.patch(url, body: jsonEncode(body), headers: headers);
  //     print('Response Status Code: ${response.statusCode}');
  //     print('Response Body: ${response.body}');
  //   } catch (e) {
  //     Get.back();
  //     showDialog(
  //       context: Get.context!,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text('เกิดข้อผิดพลาด'),
  //           contentPadding: EdgeInsets.all(20),
  //           children: [Text(e.toString())],
  //         );
  //       },
  //     );
  //   }
  // }

  Future<void> patchUserImage(String? imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print(token);

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'];

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.UpdateImage);

      var request = http.MultipartRequest('PATCH', url);
      request.fields['user_id'] = user_id.toString();
      // เพิ่มรูปภาพเข้าไป
      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'user_image', // ชื่อของ field สำหรับรูปภาพในร้องขอ
          imagePath, // ไฟล์รูปภาพ
          contentType: MediaType('image', 'jpeg/png/jpg'),
        ));
        //print(imagePath);
      }

      // ใส่ Token เข้าไปใน header เพื่อทำการยืนยันตัวตน
      request.headers['Authorization'] = 'Bearer $token';

      // ส่งคำขอ
      var response = await request.send();
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
