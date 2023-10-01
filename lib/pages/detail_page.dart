import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/controller/comments_controller.dart';
import 'package:project_mobile/model/Comments.list.dart';
import 'package:project_mobile/model/userPost.dart';
import '../components/input_textfield.dart';
import '../components/my_textfield2.dart';
import '../components/submitButton.dart';
import '../model/userPost.dart';
import 'package:flutter/src/rendering/box.dart';
import '../model/teamTest.dart';

class DetailPage extends StatefulWidget {
  final UserPost userP;
  final int post_id; // Add this line to accept post_id
  const DetailPage({Key? key, required this.userP, required this.post_id})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailState();
}

class _DetailState extends State<DetailPage> {
  List<CommentsList> comment = [];
  CommentsController commentsController = Get.put(CommentsController());

  Future<void> fetchComments() async {
    var url = Uri.parse("http://10.0.2.2:4000/comments");
    final response = await http
        .get(url); // เปลี่ยน YOUR_API_ENDPOINT_HERE เป็น URL ของ API ที่คุณใช้

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<CommentsList> fetchedComments = List<CommentsList>.from(data
          .map((dynamic commentData) => CommentsList.fromJson(commentData)));

      // เรียก setState เพื่อเปลี่ยนแปลงค่าตัวแปร comment และทำให้หน้าตาของหน้า DetailPage อัปเดต
      setState(() {
        comment = fetchedComments;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComments(); // เรียกเมื่อหน้า DetailPage ถูกสร้าง
  }

  final url = 'http://10.0.2.2:4000/uploadPostImage/';
  @override
  Widget build(BuildContext context) {
    int totalCalories = 0;
    widget.userP.ingredientsId.forEach((ingredient) {
      totalCalories += ingredient.ingredientsCal;
    });
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          (widget.userP.postName),
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
                  'http://10.0.2.2:4000/uploadPostImage/${widget.userP.postImage}',
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
                      children: widget.userP.ingredientsId.map((ingredient) {
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
                      children: widget.userP.ingredientsId.map((ingredient) {
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
                      children: widget.userP.ingredientsId.map((ingredient) {
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
              child: Text(widget.userP.postDescription),
            ),

            Text(
              '   Comments',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),

            Center(
                child: InputTextFieldWidget(
                    commentsController.commentlineController,
                    'you can comment this post')),

            SubmitButton(
              onPressed: () {
                commentsController.commentsUser(widget
                    .userP.postId); // เรียกใช้ submitPost เมื่อปุ่มส่งถูกกด
              },
              title: 'Comment',
            ),

            Container(
                padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
                margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color.fromARGB(
                          255, 130, 80, 184)), // กำหนดเส้นขอบสีเทา
                  borderRadius: BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
                ),
                child: ListView.builder(
                  shrinkWrap: true, // กำหนดให้ ListView ขยับไปตามข้อมูล
                  physics:
                      NeverScrollableScrollPhysics(), // หยุดการเลื่อนของ ListView
                  itemCount: comment.length, // จำนวนรายการความคิดเห็น
                  itemBuilder: (context, index) {
                    // กรอง comment ที่มี post_id ตรงกับ postId ของโพสต์นี้
                    if (comment[index].postId == widget.userP.postId) {
                      return Container(
                        padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
                        margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 237, 255),
                          borderRadius: BorderRadius.circular(10),
                          // กำหนดรูปร่างขอบเขต
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    'http://10.0.2.2:4000/uploadPostImage/${comment[index].userImage}',
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(255, 179, 140,
                                              255), // สีของเส้นขอบ
                                          width: 2, // ความหนาของเส้นขอบ
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            5), // กำหนดรูปร่างขอบเขต
                                        color:
                                            Color.fromARGB(255, 179, 140, 255),
                                      ),

                                      padding: EdgeInsets.all(
                                          2), // กำหนดระยะห่างรอบข้อความ
                                      child: Text(
                                        comment[index].userName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      comment[index].commentLine,
                                      style: TextStyle(
                                        color: Colors
                                            .black, // เปลี่ยนสีตามที่คุณต้องการ
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      // ถ้า comment ไม่ตรงกับ postId ของโพสต์นี้ให้แสดง SizedBox ว่าง
                      return SizedBox.shrink();
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
