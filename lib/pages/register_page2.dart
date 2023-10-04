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

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterationController registerationController =
      Get.put(RegisterationController());
  ImagePicker picker = ImagePicker();
  XFile? image;

  var isLogin = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 214, 255),
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
                    Image.asset(
                      'lib/assets/logoNew.png',
                      scale: 2.5,
                    ),
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
                        backgroundColor: Colors.white, // กำหนดสีพื้นหลัง
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
          onPressed: () =>
              registerationController.registerWithEmail(image!.path),
          title: 'Register',
        )
      ],
    );
  }
}
