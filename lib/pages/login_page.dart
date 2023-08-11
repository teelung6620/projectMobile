import 'package:flutter/material.dart';
import 'package:project_mobile/components/my_button.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:project_mobile/pages/register_page.dart';
import '../components/my_textfield.dart';
import 'home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String> login(email, password) async {
    var url = Uri.parse("http://10.0.2.2:4000/login");
    var response =
        await http.post(url, body: {'email': email, 'password': password});
    var responseData = response.body;
    debugPrint(responseData);
    if (responseData == "true") {
      return "pass";
    }
    return "fail";
  }

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    const passSnackBar = SnackBar(content: Text("Login Successed"));
    const failSnackBar = SnackBar(content: Text("Login Failed"));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 235, 255, 250),
        body: SafeArea(
          child: Center(
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
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                    color: Color.fromARGB(255, 93, 93, 93), fontSize: 16),
              ),
              const SizedBox(
                height: 30,
              ),

              //Username
              MyTextField(
                controller: emailController,
                hintText: 'Email',
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forget Password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              MyButton(
                onTap: () {
                  login(emailController.text, passwordController.text)
                      .then((value) {
                    if (value == "pass") {
                      ScaffoldMessenger.of(context).showSnackBar(passSnackBar);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(failSnackBar);
                    }
                  });
                },
              ),

              const SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account",
                    style: TextStyle(
                      color: Color(0xFF6D798E),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 52, 230, 168),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  /////////////////
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: const Text(
                      'home',
                      style: TextStyle(
                        color: Color.fromARGB(255, 105, 9, 207),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        ));
  }
}
