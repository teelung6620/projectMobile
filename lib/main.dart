import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/auth/auth_screen.dart';
import 'package:project_mobile/pages/ADMINpages/adminPage.dart';
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

  bool isAdmin(String token) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userType = decodedToken['user_type'];
    print(userType);
    return userType == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // home: const LoginPage(),
      home: (token != null && JwtDecoder.isExpired(token!) == false)
          ? (isAdmin(token)
              ? AdminPage(token: token!)
              : HomePage(token: token!))
          : LoginScreen(),

      // home: AuthScreen(token: token),
    );
  }
}

// auth/auth_screen.dart

