import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/BookMark.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/input_textfield.dart';
import '../components/input_textfieldmultiple.dart';
import '../components/my_textfield.dart';
import '../components/my_textfield2.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../components/submitButton.dart';
import '../controller/registeration_controller.dart';
import '../model/userPost.dart';
import 'detail_page.dart';

class BookPage extends StatefulWidget {
  BookPage({Key? key}) : super(key: key);
  @override
  State<BookPage> createState() => _BookState();
}

class _BookState extends State<BookPage> {
  List<UserPost> posts = [];
  List imagesUrl = [];
  List<BookMark> bookmark = [];
  int? userId;
  int? postId;

  Future getBookmark() async {
    var url = Uri.parse("http://10.0.2.2:4000/bookmarks");
    var response = await http.get(url);
    bookmark = bookMarkFromJson(response.body);

    // กรองเฉพาะโพสต์ที่มี user_id ตรงกับ userId
    bookmark = bookmark.where((element) => element.userId == userId).toList();
  }

  Future getPost() async {
    var url = Uri.parse("http://10.0.2.2:4000/post_data");
    var response = await http.get(url);
    posts = userPostFromJson(response.body);

    setState(() {
      // กรองเฉพาะโพสต์ที่มี user_id ตรงกับ userId และ postId ตรงกับ bookmark
      posts = posts
          .where((element) => bookmark
              .any((bookmarkItem) => bookmarkItem.postId == element.postId))
          .toList();

      posts.forEach((element) {
        imagesUrl.add(element.postImage);
      });
    });
  }

  Future<void> _printUserIdFromToken(String token) async {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = int.tryParse(decodedToken['user_id'].toString());

      // เรียกดึง bookmark และ post ในนี้หลังจากกำหนดค่า userId แล้ว
      await getBookmark();
      await getPost();
    } catch (error) {
      print('Error decoding token: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getBookmark();
    getPost();

    SharedPreferences.getInstance().then((prefs) {
      final String? token = prefs.getString('token');
      if (token != null) {
        _printUserIdFromToken(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 238, 255),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await getPost(); // เรียกโค้ดการดึงข้อมูลเมื่อรีเฟรช
                },
                child: SingleChildScrollView(
                  // physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: posts.length,
                        padding: EdgeInsets.all(8),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var reverseindex = posts.length - 1 - index;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 20,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          userP: posts[reverseindex],
                                          post_id: posts[reverseindex].postId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .only(
                                                      top:
                                                          10.0), // เพิ่มระยะห่างด้านบน
                                                  child: Image(
                                                    image: NetworkImage(
                                                      'http://10.0.2.2:4000/uploadPostImage/${posts[reverseindex].postImage}',
                                                    ),
                                                    width: 100,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${posts[reverseindex].totalCal} KCAL",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 50.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start, // จัดเรียงข้อความด้านซ้าย
                                              children: [
                                                Text(
                                                  posts[reverseindex].postName,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 179, 140, 255),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                  child: Text(
                                                    posts[reverseindex]
                                                        .userName,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 138, 80, 255),
                                                        fontSize: 15),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )

                                  // Align(
                                  //   child: ListTile(
                                  //     subtitleTextStyle: const TextStyle(
                                  //       fontSize: 20,
                                  //       fontWeight: FontWeight.normal,
                                  //     ),
                                  //     titleTextStyle: const TextStyle(
                                  //       color: Colors.black,
                                  //       fontSize: 25,
                                  //       fontWeight: FontWeight.normal,
                                  //     ),
                                  //     leading: Expanded(
                                  //       child: Image(
                                  //         image: NetworkImage(
                                  //           'http://10.0.2.2:4000/uploadPostImage/${newPosts[reverseindex].postImage}',
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     title: Text(
                                  //       newPosts[reverseindex].postName,
                                  //       textAlign: TextAlign.left,
                                  //     ),
                                  //     subtitle: Text(
                                  //       newPosts[reverseindex].userName,
                                  //       textAlign: TextAlign.left,
                                  //     ),
                                  //     trailing: Container(
                                  //       width:
                                  //           100, // ปรับความกว้างของช่องแสดง totalCal ตามที่คุณต้องการ
                                  //       alignment: Alignment
                                  //           .centerRight, // จัดตำแหน่งข้อความที่ด้านขวา
                                  //       child: newPosts[reverseindex].totalCal !=
                                  //               null
                                  //           ? Text(
                                  //               "${newPosts[reverseindex].totalCal}",
                                  //               style: TextStyle(
                                  //                 fontSize: 18,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             )
                                  //           : SizedBox(),
                                  //     ),
                                  //   ),
                                  // ),
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
