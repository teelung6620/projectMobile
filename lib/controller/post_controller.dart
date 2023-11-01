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

class PostController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController postidController = TextEditingController();
  TextEditingController IGDController = TextEditingController();
  List<IngredientList> ingredientsIdList = [];

  late int user_id;
  late int post_id;

  Future<void> postMenuUser(String imagePath, List<int> _selectedUnits) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      //print(token);

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'];

      var headers = {'Content-Type': 'application/json'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.postMenu),
      );

      // เพิ่มไฟล์รูปภาพลงในคำขอ
      request.files.add(await http.MultipartFile.fromPath(
        'post_image',
        imagePath,
        contentType: MediaType(
          'image',
          'jpeg/png/jpg', // หรือ 'png' หรือประเภทรูปภาพอื่น ๆ ตามที่เหมาะสม
        ),
      ));

      // เพิ่มข้อมูลอื่น ๆ ลงในคำขอ
      request.fields['post_name'] = nameController.text.trim();
      request.fields['post_description'] = descriptionController.text.trim();
      request.fields['post_types'] = typeController.text.trim();
      request.fields['ingredients_id'] = IGDController
          .text; // ถ้า IGDController มีข้อมูลเกี่ยวกับ ingredients_id
      request.fields['user_id'] =
          user_id.toString(); // เพิ่ม user_id ที่ดึงมาจาก SharedPreferences
      request.fields['ingredients_unit'] = _selectedUnits.toString();

      // ส่งคำขอ
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);

        if (json['status'] == 'ok') {
          nameController.clear();
          descriptionController.clear();
          typeController.clear();

          // Get.off(HomePage(
          //   token: token,
          // ));
        }
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

  Future<void> deletePost(int postId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      String userId = jwtDecodedToken['user_id'].toString();

      var headers = {'Content-Type': 'application/json'};

      // ส่งคำขอ DELETE ไปยังเซิร์ฟเวอร์เพื่อลบโพสต์
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.DELPost}/$postId");

      Map<String, dynamic> body = {
        'user_id': userId,
        'post_id': postId,
      };

      final request = http.Request('DELETE', url);
      request.headers.addAll(headers);
      request.body = jsonEncode(body);

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // ลบบุ๊กมาร์คสำเร็จ
        // คุณสามารถทำการอัพเดท UI หรือแอปของคุณตามที่ต้องการ
        print('Deleted successfully');
      } else {
        // ไม่สามารถลบบุ๊กมาร์คได้
        // คุณสามารถจัดการกับข้อผิดพลาดได้ตามที่คุณต้องการ
        print('Failed to delete');
      }
    } catch (e) {
      // ดักจับข้อผิดพลาด
      print('Error: $e');
    }
  }

  Future<void> updatePost(
    int postId, {
    String? name,
    String? description,
    String? type,
    String? image,
    String? ingredientsId,
    List<int>? selectedUnits,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      String userId = jwtDecodedToken['user_id'].toString();

      var headers = {'Content-Type': 'application/json'};

      // ส่งคำขอ PATCH ไปยังเซิร์ฟเวอร์เพื่ออัปเดตโพสต์
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.patchPOST}/$postId");

      Map<String, dynamic> body = {
        'user_id': userId,
        'post_id': postId,
      };

      if (name != null) {
        body['post_name'] = name;
      }
      if (description != null) {
        body['post_description'] = description;
      }
      if (type != null) {
        body['post_types'] = type;
      }
      if (image != null) {
        body['post_image'] = image;
      }
      if (ingredientsId != null) {
        body['ingredients_id'] = ingredientsId;
      }
      if (selectedUnits != null) {
        body['ingredients_unit'] = selectedUnits.toString();
      }

      final request = http.Request('PATCH', url);
      request.headers.addAll(headers);
      request.body = jsonEncode(body);

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // อัปเดตโพสต์สำเร็จ
        // คุณสามารถทำการอัพเดท UI หรือแอปของคุณตามที่ต้องการ
        print('Updated successfully');
      } else {
        // ไม่สามารถอัปเดตโพสต์ได้
        // คุณสามารถจัดการกับข้อผิดพลาดได้ตามที่คุณต้องการ
        print('Failed to update');
      }
    } catch (e) {
      // ดักจับข้อผิดพลาด
      print('Error: $e');
    }
  }

  Future<void> ReportPost(int post_id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print(token);
      print("post_id: $post_id");

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'];

      var headers = {'Content-Type': 'application/json'};

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.reportPOST);
      Map body = {
        //'comment_line': commentlineController.text.trim(),
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

        //commentlineController.clear();
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

  Future<void> deleteReport({required int reportId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      int user_id = jwtDecodedToken['user_id'];

      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.DELreportPost}/$reportId");

      Map<String, dynamic> body = {
        'report_id': reportId,
      };

      http.Response response =
          await http.delete(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        // ลบบุ๊กมาร์คสำเร็จ
        // คุณสามารถทำการอัพเดท UI หรือแอปของคุณตามที่ต้องการ
        print('Deleted successfully');
      } else {
        // ไม่สามารถลบบุ๊กมาร์คได้
        // คุณสามารถจัดการกับข้อผิดพลาดได้ตามที่คุณต้องการ
        print('Failed to delete');
      }
    } catch (e) {
      // ดักจับข้อผิดพลาด
      print('Error: $e');
    }
  }

  Future<void> patchPostData(List<int> _selectedUnits) async {
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
      request.fields['post_name'] = nameController.text.trim();
      request.fields['post_description'] = descriptionController.text.trim();
      request.fields['post_types'] = typeController.text.trim();
      request.fields['ingredients_id'] = IGDController
          .text; // ถ้า IGDController มีข้อมูลเกี่ยวกับ ingredients_id
      request.fields['user_id'] =
          user_id.toString(); // เพิ่ม user_id ที่ดึงมาจาก SharedPreferences
      request.fields['ingredients_unit'] = _selectedUnits.toString();
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

  Future<void> patchPostImage(String? imagePath, int postId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print(token);

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'];

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.UpdatePostImage);

      var request = http.MultipartRequest('PATCH', url);
      request.fields['post_id'] = postId.toString();
      // เพิ่มรูปภาพเข้าไป

      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'post_image', // ชื่อของ field สำหรับรูปภาพในร้องขอ
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
