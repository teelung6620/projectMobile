import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/model/userPost.dart';
import '../components/my_textfield2.dart';
import '../model/userPost.dart';
import 'package:flutter/src/rendering/box.dart';
import '../model/teamTest.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.userP});
  final UserPost userP;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          (userP.postName),
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 188, 144, 255),
        toolbarHeight: 60,
      ),
      backgroundColor: const Color.fromARGB(255, 231, 215, 255),
      body: Center(
        child: Text(
          userP.postName,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
