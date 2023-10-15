import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/components/commentsbutton.dart';
import 'package:project_mobile/controller/comments_controller.dart';
import 'package:project_mobile/controller/scoreController.dart';
import 'package:project_mobile/model/Comments.list.dart';
import 'package:project_mobile/model/score.list.dart';
import 'package:project_mobile/model/userPost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/input_textfield.dart';
import '../components/my_textfield2.dart';
import '../components/submitButton.dart';
import '../model/userPost.dart';
import 'package:flutter/src/rendering/box.dart';
import '../model/teamTest.dart';

class DetailPage extends StatefulWidget {
  final UserPost userP;
  final int post_id;
  const DetailPage({Key? key, required this.userP, required this.post_id})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailState();
}

class _DetailState extends State<DetailPage> {
  List<CommentsList> comment = [];
  CommentsController commentsController = Get.put(CommentsController());
  ScoreController scoreController = Get.put(ScoreController());
  String _selectedItem = "1";
  List<String> unitNameOptions = ["1", "2", "3", "4", "5"];
  // ScoreController scoreController = Get.find<ScoreController>();
  List<ScoreList> scorelist = [];
  int? userId;
  int? postId;

  Future getScore() async {
    var url = Uri.parse("http://10.0.2.2:4000/scores");
    var response = await http.get(url);
    scorelist = scoreListFromJson(response.body);

    // กรองเฉพาะโพสต์ที่มี user_id และ post_id ตรงกับ userId และ postId
    scorelist = scorelist
        .where((element) =>
            element.userId == userId && element.postId == widget.post_id)
        .toList();
    print('userId: $userId');
    print('postId: ${widget.post_id}');
  }

  Future<void> _printUserIdFromToken(String token) async {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = int.tryParse(decodedToken['user_id'].toString());

      print(userId);

      // เรียกดึง bookmark และ post ในนี้หลังจากกำหนดค่า userId แล้ว
      // await getBookmark();
      // await getPost();
    } catch (error) {
      print('Error decoding token: $error');
    }
  }

  Future<void> fetchComments() async {
    var url = Uri.parse("http://10.0.2.2:4000/comments");
    final response = await http
        .get(url); // เปลี่ยน YOUR_API_ENDPOINT_HERE เป็น URL ของ API ที่คุณใช้

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<CommentsList> fetchedComments = List<CommentsList>.from(data
          .map((dynamic commentData) => CommentsList.fromJson(commentData)));

      setState(() {
        comment = fetchedComments;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> fetchData() async {
    // Put any data fetching logic here, for example, calling fetchComments()
    await fetchComments();
    await getScore();

    // Call setState to trigger a refresh of the page
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getScore();
    fetchComments();

    SharedPreferences.getInstance().then((prefs) {
      final String? token = prefs.getString('token');
      if (token != null) {
        _printUserIdFromToken(token);
      }
    });
  }

  final url = 'http://10.0.2.2:4000/uploadPostImage/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            (widget.userP.postName),
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF363062),
          toolbarHeight: 60,
        ),
        backgroundColor: const Color.fromARGB(255, 231, 215, 255),
        body: RefreshIndicator(
          onRefresh: () async {
            await fetchData();
            //await getScore();
          },
          color: Color.fromARGB(255, 142, 61, 255),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                // สีบน
                color: Color(0xFF4D4C7D), // สีล่าง
              ),
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
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        '(' +
                            (widget.userP.averageScore ?? '0').toString() +
                            ')', // ใช้ '0' หาก averageScore เป็น null
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      for (int i = 1; i <= 5; i++)
                        Icon(
                          Icons.star,
                          color: i <=
                                  double.parse(widget.userP.averageScore ??
                                      '0') // แปลงเป็น double โดยใช้ double.parse
                              ? const Color.fromARGB(255, 255, 203, 59)
                              : Colors.grey,
                          size: 12.0,
                        ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  Text(
                    '   ส่วนผสม',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
                    margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
                    decoration: BoxDecoration(
                      color: const Color(0xFF363062),
                      border: Border.all(
                          color: Color(0xFFF99417)), // กำหนดเส้นขอบสีเทา
                      borderRadius:
                          BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.25, // กำหนดความกว้างของคอลัมน์ 1
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                widget.userP.ingredientsId.map((ingredient) {
                              return Text(
                                '  ' + ingredient.ingredientsName,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
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
                            children:
                                widget.userP.ingredientsId.map((ingredient) {
                              return Text(
                                ingredient.ingredientsUnits.toString() +
                                    '   ' +
                                    ingredient.ingredientsUnitsName +
                                    ' ',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
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
                            children:
                                widget.userP.ingredientsId.map((ingredient) {
                              return Text(
                                ingredient.ingredientsCal.toString() +
                                    '   แคลอรี่',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
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
                        color: Color(0xFF363062),
                        border: Border.all(
                            color: Color(0xFFF99417)), // กำหนดเส้นขอบสีเทา
                        borderRadius:
                            BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
                      ),
                      child: Text(
                        'TOTAL CALORIES : ${widget.userP.totalCal}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.left,
                      )),

                  Text(
                    '   วิธีทำ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
                    margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
                    decoration: BoxDecoration(
                      color: Color(0xFF363062),
                      border: Border.all(
                          color: Color(0xFFF99417)), // กำหนดเส้นขอบสีเทา
                      borderRadius:
                          BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
                    ),
                    child: Text(
                      widget.userP.postDescription,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xFF363062),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButton(
                            value: _selectedItem,
                            dropdownColor: Color(0xFF363062),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            iconEnabledColor: Colors.white,
                            items: unitNameOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Row(
                                  // เพิ่ม Row สำหรับการจัดวางแสดง Icon หลังจาก Text
                                  children: [
                                    Text(option),
                                    if (option ==
                                        _selectedItem) // เพิ่มดาวหรือสัญลักษณ์อื่นที่คุณต้องการ
                                      Icon(Icons.star, color: Colors.yellow),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedItem = newValue ?? '';
                                scoreController.scoreController.text =
                                    _selectedItem;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            print('userId: $userId');
                            print('postId: ${widget.post_id}');
                            print('scorelist: $scorelist');

                            if (scorelist.any((score) =>
                                score.userId == userId &&
                                score.postId == widget.post_id)) {
                              print('Score already exists, so update it.');
                              await scoreController.updateScore(widget.post_id);
                            } else {
                              print(
                                  'Score does not exist, so create a new score.');
                              await scoreController.scorePost(widget.post_id);
                            }

                            // เมื่อคะแนนถูกเพิ่มหรืออัปเดต, ส่งค่า true กลับไปยังหน้า ListPage
                            Navigator.pop(context, true);
                          },
                          child: Text('ให้คะแนน'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(
                                255, 104, 93, 184), // สีพื้นหลังของปุ่ม
                            foregroundColor:
                                Colors.white, // สีข้อความข้างในปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // รูปร่างขอบ
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    '   Comments',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Center(
                      child: InputTextFieldWidget(
                          commentsController.commentlineController,
                          'Add a comment...')),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: CommentButton(
                      onPressed: () {
                        commentsController.commentsUser(widget.userP
                            .postId); // เรียกใช้ submitPost เมื่อปุ่มส่งถูกกด
                      },
                      title: 'Comment',
                    ),
                  ),

                  Container(
                    // padding: EdgeInsets.all(10),
                    // margin: EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   border: Border.all(
                    //     color: Color.fromARGB(255, 130, 80, 184),
                    //   ),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comment.length,
                      itemBuilder: (context, index) {
                        if (comment[index].postId == widget.userP.postId) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF363062),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFF4D4C7D),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xFF4D4C7D),
                                          ),
                                          padding: EdgeInsets.all(2),
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
                                            color: Colors.white,
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
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
