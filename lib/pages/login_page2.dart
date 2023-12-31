// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_mobile/pages/register_page2.dart';

import '../components/input_textfield.dart';
import '../components/submitButton.dart';
import '../controller/login_controller.dart';
import '../controller/registeration_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  RegisterationController registerationController =
      Get.put(RegisterationController());

  Future _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('กรุณากรอก OTP จาก email ของคุณ'),
          content: TextField(
            controller: registerationController.verifyController,
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
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
                  children: <Widget>[
                    const SizedBox(height: 80),
                    Image.asset(
                      'lib/assets/logoNew.png',
                      scale: 2.5,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Welcome back you\'ve been missed!',
                      style: TextStyle(
                          color: Color.fromARGB(255, 93, 93, 93), fontSize: 16),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isLogin.value ? loginWidget() : loginWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account"),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: const Text(
                            ' Sign Up',
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

  Widget loginWidget() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(loginController.emailController, 'Email'),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(loginController.passwordController, 'Password'),
        SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () {
            if (loginController.emailController.text.isNotEmpty &&
                loginController.passwordController.text.isNotEmpty) {
              // เช็คให้แน่ใจว่า Email และ Password ถูกกรอก
              loginController.loginWithEmail(); // เริ่มกระบวนการเข้าสู่ระบบ
              _showDeleteConfirmationDialog();
            } else {
              // หากไม่มี Email หรือ Password ให้แสดงข้อความผิดพลาด
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('กรุณากรอก Email และ Password ให้ครบถ้วน'),
                ),
              );
            }
          },
          title: 'Login',
        )
      ],
    );
  }
}
