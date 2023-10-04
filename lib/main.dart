import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/auth/auth_screen.dart';
import 'package:project_mobile/pages/home.dart';
import 'package:project_mobile/pages/login_page.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const LoginPage(),
      home: (token != null && JwtDecoder.isExpired(token!) == false)
          ? HomePage(token: token!)
          : LoginScreen(),
    );
  }
}
