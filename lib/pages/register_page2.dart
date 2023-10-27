// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_mobile/pages/login_page2.dart';

import '../components/input_textfield.dart';
import '../components/submitButton.dart';
import '../controller/login_controller.dart';
import '../controller/registeration_controller.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterationController registerationController =
      Get.put(RegisterationController());
  ImagePicker picker = ImagePicker();
  XFile? image;
  List<User> userList = [];

  Future getUser() async {
    var url = Uri.parse("http://10.0.2.2:4000/login");
    var response = await http.get(url);
    userList = userFromJson(response.body);

    setState(() {
      userList;
      print(userList);
    });

    // ตรวจสอบว่ามีอีเมลที่ซ้ำกันหรือไม่
    // if (userList.any((user) =>
    //     user.userEmail ==
    //     registerationController.emailController.text.trim())) {
    //   _showDeleteConfirmationDialog();
    // }
  }

  Future _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('กรุณากรอก OTP จาก email ของคุณ'),
          content: TextField(
            controller: registerationController.verifyController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
                registerationController.deleteUser();
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // ยืนยันการลบ
                registerationController.verifyEmail();
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  var isLogin = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Center(
            child: Obx(
              () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    // Image.asset(
                    //   'lib/assets/logoNew.png',
                    //   scale: 2.5,
                    // ),
                    TextButton(
                      onPressed: () async {
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            image = pickedFile;
                          });
                          // ทำอะไรกับ imagePath ต่อไป
                        }
                      },
                      child: Center(
                          child: CircleAvatar(
                        radius: 100, // กำหนดรัศมีของ Circle Avatar
                        backgroundColor: Color.fromARGB(
                            255, 231, 231, 231), // กำหนดสีพื้นหลัง
                        child: image != null
                            ? ClipOval(
                                child: Image.file(
                                  File(image!.path),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                'เลือกรูปภาพของคุณ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 114, 26, 236),
                                ),
                              ),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Thank you for coming into our lives.'),
                    SizedBox(
                      height: 20,
                    ),
                    isLogin.value ? registerWidget() : registerWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account '),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromARGB(255, 113, 49, 210),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Column(
      children: [
        InputTextFieldWidget(registerationController.nameController, 'Name'),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          registerationController.emailController,
          'Email address',
        ),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registerationController.passwordController, 'Password'),
        SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () {
            if (!userList.any((user) =>
                user.userEmail !=
                registerationController.emailController.text.trim())) {
              registerationController.registerWithEmail(image!.path);
              _showDeleteConfirmationDialog();
            }
          },
          title: 'Register',
        )
      ],
    );
  }
}
