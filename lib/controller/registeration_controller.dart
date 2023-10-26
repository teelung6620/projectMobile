import 'dart:convert';
import 'dart:io'; // เพิ่ม import นี้

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart'; // เพิ่ม import นี้
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
  TextEditingController verifyController = TextEditingController();
  File? userImage; // เพิ่มตัวแปร userImage
  String userId = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // ...

  Future<void> registerWithEmail(String imagePath) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);

      // เพิ่มรูปภาพไปยัง multipart request
      var request = http.MultipartRequest('POST', url);
      request.fields['user_name'] = nameController.text;
      request.fields['user_email'] = emailController.text.trim();
      request.fields['user_password'] = passwordController.text;

      request.files.add(await http.MultipartFile.fromPath(
        'user_image',
        imagePath,
        contentType: MediaType('image', 'jpeg/png/jpg'),
      ));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final json = jsonDecode(await response.stream.bytesToString());
        userId = json['userId'].toString();

        // เก็บค่า user_id จาก response

        if (json['status'] == 'ok') {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          // Get.off(LoginScreen());
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

  // สร้างฟังก์ชันสำหรับยืนยันอีเมล
  Future<void> verifyEmail() async {
    try {
      final url = Uri.parse(ApiEndPoints.baseUrl + '/verify');
      final response = await http
          .patch(url, body: {'user_id': userId, 'code': verifyController.text});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Email verified and data deleted successfully') {
          Get.off(LoginScreen());
          // ยืนยันอีเมลสำเร็จ ทำสิ่งที่คุณต้องการที่นี่
        } else {
          // ผิดพลาดในการยืนยันอีเมล
        }
      } else {
        // ผิดพลาดในการส่งคำขอ
      }
    } catch (e) {
      // ผิดพลาดอื่น ๆ
    }
  }

  Future<void> deleteUser() async {
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl + '/DELregister/$userId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'ok') {
          // ลบบัญชีผู้ใช้สำเร็จ ทำสิ่งที่คุณต้องการที่นี่
        } else {
          // ลบบัญชีผู้ใช้ไม่สำเร็จ
        }
      } else {
        // ผิดพลาดในการส่งคำขอ
      }
    } catch (e) {
      // ผิดพลาดอื่น ๆ
    }
  }

  // เพิ่มฟังก์ชันสำหรับการเลือกรูปภาพ
  Future<void> pickUserImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      update(); // อัพเดต UI
    }
  }
}
