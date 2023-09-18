import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/model/userPost.dart';
import '../components/my_textfield2.dart';
import '../model/userPost.dart';
import 'package:flutter/src/rendering/box.dart';
import '../model/teamTest.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key}) : super(key: key);
  @override
  State<Bookmark> createState() => _BookState();
}

class _BookState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "Book Page",
            style: TextStyle(fontSize: 50),
          ),
        ),
      ],
    );
  }
}
