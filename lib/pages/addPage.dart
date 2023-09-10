import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_mobile/pages/registTest.dart';

import '../components/my_textfield.dart';
import '../components/my_textfield2.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);

  final postnameController = TextEditingController();
  final solutController = TextEditingController();

  final picker = ImagePicker();

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // ทำสิ่งที่คุณต้องการกับรูปภาพที่เลือก
      // เช่น การแสดงรูปภาพในแอปหรือการอัปโหลดไปยังเซิร์ฟเวอร์ Node.js
    }
  }

  Future<void> uploadImage(String imagePath) async {
  final url = Uri.parse('YOUR_NODEJS_SERVER_UPLOAD_URL'); // เปลี่ยนเป็น URL ของเซิร์ฟเวอร์ Node.js

  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('image', imagePath));

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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          MyTextField2(
              controller: postnameController,
              hintText: 'name',
              obscureText: false),
          const SizedBox(height: 20),
          MyTextField2(
              controller: solutController,
              hintText: 'Solution',
              obscureText: false),
          const SizedBox(height: 20),
          TextButton(onPressed: chooseImage, child: Text('choose your image'))
        ],
      ),
    ));
  }
}
