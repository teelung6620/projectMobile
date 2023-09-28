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

  late String user_id;

  Future<void> postMenuUser(String imagePath, List<int> _selectedUnits) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print(token);

      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      user_id = jwtDecodedToken['user_id'].toString();

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
          user_id; // เพิ่ม user_id ที่ดึงมาจาก SharedPreferences
      request.fields['ingredients_unit'] = _selectedUnits.toString();

      // ส่งคำขอ
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);

        nameController.clear();
        descriptionController.clear();
        typeController.clear();

        Get.off(HomePage(
          token: token,
        ));
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
