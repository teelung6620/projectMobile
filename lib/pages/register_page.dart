import 'package:flutter/material.dart';
import 'package:project_mobile/components/my_button.dart';
import '../components/my_textfield.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  void RegistUserIn() {}

  @override
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  Future sign_up() async {
    String url = "http://localhost:4000/";
    final respone = await http.post(Uri.parse(url), body: {
      'name': usernameController.text,
      'pass': passwordController.text,
      'email': emailController.text,
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 235, 255, 250),
        body: SafeArea(
          child: Center(
            child: Form(
              child: Column(children: [
                const SizedBox(height: 50),
                Image.asset(
                  'lib/assets/Logo.png',
                  scale: 2.5,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Registeration',
                  style: TextStyle(
                      color: Color.fromARGB(255, 93, 93, 93), fontSize: 16),
                ),
                const SizedBox(
                  height: 30,
                ),

                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
                ),

                //Username
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
                ),

                //Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(
                  height: 10,
                ),

                //Forget Password?
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'Forget Password?',
                //         style: TextStyle(color: Colors.black),
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(
                  height: 10,
                ),

                MyButton2(
                  onTap: RegistUserIn,
                ),

                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 50,
                        )),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
