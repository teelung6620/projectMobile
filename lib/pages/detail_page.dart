import 'dart:convert';
import 'dart:ffi';
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

  final url = 'http://10.0.2.2:4000/uploadPostImage/';
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Image(
              image: NetworkImage(
                'http://10.0.2.2:4000/uploadPostImage/${userP.postImage}',
              ),
              width: 300, // กำหนดความกว้าง
              height: 300,
            ),
            Text(
              userP.userName,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.right,
            ),
            Text(
              'ส่วนผสม',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            Row(
              children: [
                Column(
                    children: userP.separatedNingred.map((ingredient) {
                  return Text(
                    ingredient + ' ',
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  );
                }).toList()),
                Column(
                    children: userP.separatedUingred.map((gram) {
                  int intGram = int.tryParse(gram) ?? 0;
                  String textToDisplay = gram;
                  if (intGram >= 100) {
                    textToDisplay = intGram.toString() + ' กรัม';
                  } else {
                    textToDisplay = intGram.toString() + ' ช้อนชา';
                  }
                  return Text(
                    textToDisplay,
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  );
                }).toList()),
                Column(
                    children: userP.separatedCingred.map((cal) {
                  return Text(
                    ' CAL : ' + cal,
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  );
                }).toList()),
              ],
            ),
            Text(userP.cingredAll),
            Text(
              'วิธีทำ',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(userP.postDescription),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
