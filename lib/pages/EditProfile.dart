import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/BookMark.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/pages/ListPage.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/input_textfield.dart';
import '../components/input_textfieldmultiple.dart';
import '../components/my_textfield.dart';
import '../components/my_textfield2.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../components/submitButton.dart';
import '../controller/bookmarkController.dart';
import '../controller/login_controller.dart';
import '../controller/registeration_controller.dart';
import '../model/userPost.dart';
import '../utils/api_endpoint.dart';
import 'ADMINpages/adminPage.dart';
import 'detail_page.dart';
import 'home.dart';

import 'package:dio/dio.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImage;
  final String userPassword;
  EditProfilePage(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.userImage,
      required this.userPassword})
      : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePage> {
  List<UserPost> posts = [];
  List imagesUrl = [];
  List<BookMark> bookmark = [];
  int? userId;
  int? postId;
  TextEditingController userNameController = TextEditingController();
  LoginController patchController = Get.put(LoginController());

  final ListPage listpage = ListPage();
  XFile? image;
  final picker = ImagePicker();
  //String? userIMAGE =  widget.userImage;
  Future getPost() async {
    var url = Uri.parse("http://10.0.2.2:4000/post_data");
    var response = await http.get(url);
    posts = userPostFromJson(response.body);

    setState(() {
      // กรองเฉพาะโพสต์ที่มี user_id ตรงกับ userId และ postId ตรงกับ bookmark
      posts = posts
          .where((element) => bookmark
              .any((bookmarkItem) => bookmarkItem.postId == element.postId))
          .toList();

      posts.forEach((element) {
        imagesUrl.add(element.postImage);
      });
    });
  }

  Future<void> _printUserIdFromToken(String token) async {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = int.tryParse(decodedToken['user_id'].toString());

      print(userId);

      // เรียกดึง bookmark และ post ในนี้หลังจากกำหนดค่า userId แล้ว
      // await getBookmark();
      // await getPost();
    } catch (error) {
      print('Error decoding token: $error');
    }
  }

  Future _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการเปลี่ยนแปลง'),
          content: Text('คุณต้องการเปลี่ยนแปลงข้อมูลนี้ ใช่หรือไม่?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 108, 37, 207), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 108, 37, 207), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                saveUserName();
                // if (image != null) {
                //   saveUserImage();
                // }
                Navigator.of(context).pop(true); // ยืนยันการลบ
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  void saveUserName() async {
    // Get the token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      // Call the method to save the user name and email
      final LoginController loginController = Get.find();
      await loginController.patchUserData(); // ส่งรูปภาพด้วย

      // Optionally, you can show a confirmation or success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data updated successfully'),
        ),
      );
    } else {
      // Handle the case where token is null
    }
  }

  void saveUserImage() async {
    // Get the token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      // Call the method to save the user name and email
      final LoginController loginController = Get.find();
      await loginController.patchUserImage(image!.path); // ส่งรูปภาพด้วย

      // Optionally, you can show a confirmation or success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data updated successfully'),
        ),
      );
    } else {
      // Handle the case where token is null
    }
  }

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // image = XFile('http://10.0.2.2:4000/uploadPostImage/${widget.userImage}');
    // print(image);

    getPost();
    patchController.nameController.text = widget.userName;
    patchController.emailController.text = widget.userEmail;
    //patchController.passwordController.text = widget.userPassword;
    // image = XFile('http://10.0.2.2:4000/uploadPostImage/${widget.userImage}');

    SharedPreferences.getInstance().then((prefs) {
      final String? token = prefs.getString('token');
      if (token != null) {
        _printUserIdFromToken(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 63, 57, 109),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            'แก้ไขโปรไฟล์',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF363062),
          toolbarHeight: 60,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  chooseImage();
                },
                child: Center(
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: image != null
                        ? Image.file(
                            File(image!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : widget.userImage != null
                            ? Image.network(
                                'http://10.0.2.2:4000/uploadPostImage/${widget.userImage}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'เลือกรูปภาพของคุณ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 114, 26, 236),
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
              Text(
                'แตะที่รูปภาพเพื่อเปลี่ยน',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: patchController.nameController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 102, 31, 243))),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 206, 206))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: patchController.emailController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 102, 31, 243))),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 206, 206))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Spacer(),
              SubmitButton(
                  onPressed: () {
                    // Call the method to save the user name
                    _showDeleteConfirmationDialog();
                  },
                  title: 'SAVE'),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
