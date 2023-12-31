import 'package:flutter/material.dart';
import 'package:project_mobile/model/register_request_model.dart';
import '../components/my_textfield.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  void RegistUserIn() {}
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? userEmail;
  String? userPassword;
  String? userName;

  @override
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  Future register(email, password, name) async {
    var url = Uri.parse("http://10.0.2.2:4000/register");
    var response = await http
        .post(url, body: {'email': email, 'password': password, 'name': name});
    // var responseData = response.body;
    // debugPrint(responseData);
    if (response.statusCode == 200) {
      // ลงทะเบียนสำเร็จ
      // นำผู้ใช้ไปยังหน้าอื่นๆ หรือทำอย่างอื่นตามความต้องการ
    } else {
      // ลงทะเบียนไม่สำเร็จ
      // แสดงข้อความผิดพลาดหรือทำอย่างอื่นตามความต้องการ
    }
  }

  Widget build(BuildContext context) {
    const passSnackBar = SnackBar(content: Text("Register Successed"));
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

                const SizedBox(
                  height: 10,
                ),

                MyButton2(
                  onTap: () {
                    if (validateAndSave()) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      RegisterRequestModel model = RegisterRequestModel(
                          userEmail: userEmail!,
                          userName: userName!,
                          userPassword: userPassword!);

                      APIService.register(model).then((response) {
                        setState(() {
                          isApiCallProcess = false;
                        });
                        if (response.users != null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(passSnackBar);
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        } else {}
                      });
                    }
                    // register(usernameController.text, emailController.text,
                    //         passwordController.text)
                    //     .then((value) {
                    //   if (value == "pass") {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HomePage()),
                    //     );
                    //   }
                    // });
                  },
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

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
