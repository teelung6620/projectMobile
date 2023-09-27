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
    int totalCalories = 0;
    userP.ingredientsId.forEach((ingredient) {
      totalCalories += ingredient.ingredientsCal;
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center, // กำหนดจุดศูนย์กลางให้รูปภาพ
              child: Image(
                image: NetworkImage(
                  'http://10.0.2.2:4000/uploadPostImage/${userP.postImage}',
                ),
                width: 300, // กำหนดความกว้าง
                height: 300,
              ),
            ),
            // Text(
            //   userP.userName + '\n',
            //   style: const TextStyle(fontSize: 20),
            //   textAlign: TextAlign.right,
            // ),
            Text(
              '   ส่วนผสม',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
              margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color:
                        Color.fromARGB(255, 130, 80, 184)), // กำหนดเส้นขอบสีเทา
                borderRadius: BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.25, // กำหนดความกว้างของคอลัมน์ 1
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userP.ingredientsId.map((ingredient) {
                        return Text(
                          '  ' + ingredient.ingredientsName,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.2, // กำหนดความกว้างของคอลัมน์ 2
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: userP.ingredientsId.map((ingredient) {
                        return Text(
                          ingredient.ingredientsUnits.toString() +
                              '   ' +
                              ingredient.ingredientsUnitsName +
                              ' ',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.3, // กำหนดความกว้างของคอลัมน์ 2
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: userP.ingredientsId.map((ingredient) {
                        return Text(
                          ingredient.ingredientsCal.toString() + '   แคลอรี่',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
              margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color:
                        Color.fromARGB(255, 130, 80, 184)), // กำหนดเส้นขอบสีเทา
                borderRadius: BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
              ),
              child: Text(
                'TOTAL CALORIES : $totalCalories ',
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.left,
              ),
            ),

            Text(
              '   วิธีทำ',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
              margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color:
                        Color.fromARGB(255, 130, 80, 184)), // กำหนดเส้นขอบสีเทา
                borderRadius: BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
              ),
              child: Text(userP.postDescription),
            ),

            Text(
              '   Comments',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
