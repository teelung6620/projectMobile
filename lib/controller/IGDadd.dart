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

class IGDController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController unitNameController = TextEditingController();
  TextEditingController calController = TextEditingController();
  // TextEditingController imageController = TextEditingController();
  //TextEditingController postidController = TextEditingController();
  // TextEditingController IGDController = TextEditingController();
  // List<IngredientList> ingredientsIdList = [];

  late String user_id;

  Future<void> IGDadder() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString("token");
      // //print(token);

      // Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      // user_id = jwtDecodedToken['user_id'].toString();

      var headers = {'Content-Type': 'application/json'};
      // var request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.addIGD),
      // );

      // เพิ่มข้อมูลอื่น ๆ ลงในคำขอ

      // ส่งคำขอ
      // final response = await request.send();

      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.addIGD);
      Map body = {
        'ingredients_name': nameController.text.trim(),
        'ingredients_units': unitController.text.trim(),
        'ingredients_unitsName': unitNameController.text.trim(),
        'ingredients_cal': calController.text.trim(),
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        nameController.clear();
        unitController.clear();
        unitNameController.clear();
        calController.clear();
        Get.snackbar(
          'สำเร็จ',
          'เพิ่มส่วนผสมแล้ว',
          snackPosition: SnackPosition.TOP,
        );
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'ผิดพลาด',
          'ผสมนี้มีอยู่แล้ว',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'เกิดข้อผิดพลาดในการเพิ่มส่วนผสม',
          snackPosition: SnackPosition.BOTTOM,
        );
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
