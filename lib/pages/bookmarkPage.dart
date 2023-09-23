import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/input_textfield.dart';
import '../components/input_textfieldmultiple.dart';
import '../components/my_textfield.dart';
import '../components/my_textfield2.dart';
import 'package:http/http.dart' as http;

import '../components/submitButton.dart';
import '../controller/registeration_controller.dart';

class BookPage extends StatefulWidget {
  BookPage({Key? key}) : super(key: key);
  @override
  State<BookPage> createState() => _BookState();
}

class _BookState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
