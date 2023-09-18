import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/post_controller.dart';
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

class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);
  @override
  State<AddPage> createState() => _AddState();
}

class _AddState extends State<AddPage> {
  PostController postController = Get.put(PostController());
  late int user_id;
  _getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print(token);

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);

    user_id = jwtDecodedToken['user_id'];
    print(user_id);
  }

  final picker = ImagePicker();

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // ทำสิ่งที่คุณต้องการกับรูปภาพที่เลือก
      // เช่น การแสดงรูปภาพในแอปหรือการอัปโหลดไปยังเซิร์ฟเวอร์ Node.js
    }
  }

  Future<void> uploadImage(String imagePath) async {
    final url = Uri.parse(
        'localhost:4000/uploadPostImage'); // เปลี่ยนเป็น URL ของเซิร์ฟเวอร์ Node.js

    var request = http.MultipartRequest('PATCH', url);
    request.files
        .add(await http.MultipartFile.fromPath('post_image', imagePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Upload success');
      } else {
        print('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          // MyTextField2(
          //     controller: postnameController,
          //     hintText: 'name',
          //     obscureText: false),
          // const SizedBox(height: 20),
          // MyTextField2(
          //     controller: DescriptController,
          //     hintText: 'Solution',
          //     obscureText: false),
          // const SizedBox(height: 20),
          PostWidget(),
          TextButton(onPressed: chooseImage, child: Text('choose your image')),

          SubmitButton(
            onPressed: () //=> postController.postMenuUser(),
                {
              _getSavedToken();
            },
            title: 'SUBMIT',
          ),
        ],
      ),
    ));
  }

  Widget PostWidget() {
    return Column(
      children: [
        InputTextFieldWidget(postController.nameController, 'Name'),
        SizedBox(
          height: 20,
        ),
        InputTextFieldMultipleWidget(
          postController.descriptionController,
          'Description',
        ),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          postController.typeController,
          'Types',
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
