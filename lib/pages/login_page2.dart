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

  var isLogin = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 249, 255),
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
          onPressed: () => loginController.loginWithEmail(),
          title: 'Login',
        )
      ],
    );
  }
}
