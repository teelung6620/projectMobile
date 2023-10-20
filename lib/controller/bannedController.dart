import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:http/http.dart' as http;
import 'package:project_mobile/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/ADMINpages/adminPage.dart';
import '../pages/homeTest.dart';
import '../utils/api_endpoint.dart';

class BannedController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> BanUser(int userId) async {
    final SharedPreferences? prefs = await _prefs;
    final token = prefs?.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var url = Uri.parse(ApiEndPoints.baseUrl + '/BANuser/$userId');
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        // แบนผู้ใช้สำเร็จ
        print("แบนผู้ใช้สำเร็จ");
        // ทำอย่างอื่นที่คุณต้องการหลังจากการแบนผู้ใช้
      } else {
        // ไม่สามารถแบนผู้ใช้
        print("ไม่สามารถแบนผู้ใช้");
        // จัดการข้อผิดพลาดหรือแจ้งเตือนให้ผู้ใช้ทราบตามที่คุณต้องการ
      }
    } catch (error) {
      // ข้อผิดพลาดในการเชื่อมต่อหรือร้องขอ
      print("เกิดข้อผิดพลาดในการเชื่อมต่อหรือร้องขอ: $error");
      // จัดการข้อผิดพลาดหรือแจ้งเตือนให้ผู้ใช้ทราบตามที่คุณต้องการ
    }
  }

  Future<void> UnBanUser(int userId) async {
    final SharedPreferences? prefs = await _prefs;
    final token = prefs?.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var url = Uri.parse(ApiEndPoints.baseUrl + '/UNBANuser/$userId');
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        // แบนผู้ใช้สำเร็จ
        print("ปลดแบนผู้ใช้สำเร็จ");
        // ทำอย่างอื่นที่คุณต้องการหลังจากการแบนผู้ใช้
      } else {
        // ไม่สามารถแบนผู้ใช้
        print("ไม่สามารถปลดแบนผู้ใช้");
        // จัดการข้อผิดพลาดหรือแจ้งเตือนให้ผู้ใช้ทราบตามที่คุณต้องการ
      }
    } catch (error) {
      // ข้อผิดพลาดในการเชื่อมต่อหรือร้องขอ
      print("เกิดข้อผิดพลาดในการเชื่อมต่อหรือร้องขอ: $error");
      // จัดการข้อผิดพลาดหรือแจ้งเตือนให้ผู้ใช้ทราบตามที่คุณต้องการ
    }
  }
}
