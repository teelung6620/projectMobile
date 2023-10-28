import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/bannedController.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/BookMark.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/model/Report.list.dart';
import 'package:project_mobile/model/user.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../model/userPost.dart';
import '../detail_page.dart';

class UserListPage extends StatefulWidget {
  UserListPage({Key? key}) : super(key: key);
  @override
  State<UserListPage> createState() => _UserListState();
}

class _UserListState extends State<UserListPage> {
  List<UserPost> posts = [];
  List imagesUrl = [];
  List<User> userList = [];
  int? userId;
  int? postId;
  int? banned;
  Future getUser() async {
    var url = Uri.parse("http://10.0.2.2:4000/login");
    var response = await http.get(url);
    userList = userFromJson(response.body);
    // print(userList);

    setState(() {
      userList;
    });

    // กรองเฉพาะโพสต์ที่มี user_id ตรงกับ userId
    // report = report.where((element) => element.userId == userId).toList();
  }

  Future<List<User>> fetchUsers() async {
    var url = Uri.parse("http://10.0.2.2:4000/login");
    var response = await http.get(url);
    List<User> users = userFromJson(response.body);
    return users;
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

  Future _showBanfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการแบน'),
          content: Text('คุณต้องการแบนผู้ใช้นี้ใช่หรือไม่?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // ยืนยันการลบ
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  Future _showUnbanConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการปลดแบน'),
          content: Text('คุณต้องการปลดแบนผู้ใช้นี้ใช่หรือไม่?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF363062), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // ยืนยันการลบ
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUser();
    //getPost();

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
        // backgroundColor: Color.fromARGB(255, 245, 238, 255),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF4D4C7D)),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Color.fromARGB(255, 63, 12, 124), // สีบน
                  //     Color.fromARGB(255, 175, 110, 255), // สีล่าง
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  color: Color(0xFF363062),
                  // border: Border.all(
                  //   color: Colors.black, // สีขอบ
                  //   width: 2.0, // ความหนาขอบ
                  // ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0), // ความโค้งขอบ
                  ),
                ),
                padding: EdgeInsets.all(20.0), // ความห่างระหว่างขอบและเนื้อหา

                child: Text(
                  'USERS',
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F5F5)),
                ),
              ),
              Expanded(
                  child: FutureBuilder<List<User>>(
                      future: fetchUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // กำลังโหลดข้อมูล - แสดง Loading Animation ที่คุณต้องการ
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          // หากเกิดข้อผิดพลาด
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          // โหลดข้อมูลสำเร็จ - แสดงข้อมูลที่โหลด
                          List<User> userList = snapshot.data!;
                          return RefreshIndicator(
                            onRefresh: () async {
                              await getUser();
                            },
                            child: SingleChildScrollView(
                              // physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: userList.length,
                                    padding: EdgeInsets.all(8),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var reverseindex =
                                          userList.length - 1 - index;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: 20,
                                            height: 130,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top:
                                                                        10.0), // เพิ่มระยะห่างด้านบน
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                'http://10.0.2.2:4000/uploadPostImage/${userList[reverseindex].userImage}',
                                                              ),
                                                              radius: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 50.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // จัดเรียงข้อความด้านซ้าย
                                                        children: [
                                                          Text(
                                                            userList[
                                                                    reverseindex]
                                                                .userName,
                                                            style: TextStyle(
                                                              color: userList[reverseindex]
                                                                          .banned ==
                                                                      1
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 20,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Color(
                                                                    0xFF363062),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Text(
                                                              userList[
                                                                      reverseindex]
                                                                  .userEmail,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF363062),
                                                                  fontSize: 15),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            bool confirmBan =
                                                                await _showBanfirmationDialog();
                                                            if (confirmBan) {
                                                              await BannedController()
                                                                  .BanUser(
                                                                userList[
                                                                        reverseindex]
                                                                    .userId,
                                                              );

                                                              setState(() {
                                                                getUser(); // เรียกใช้งาน getUser() เพื่อรีเฟรชหน้าจอ
                                                              });
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .airplanemode_active,
                                                            color: Color(
                                                                0xFF363062),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            bool confirmUnban =
                                                                await _showUnbanConfirmationDialog();
                                                            if (confirmUnban) {
                                                              await BannedController()
                                                                  .UnBanUser(
                                                                userList[
                                                                        reverseindex]
                                                                    .userId,
                                                              );

                                                              setState(() {
                                                                getUser(); // เรียกใช้งาน getUser() เพื่อรีเฟรชหน้าจอ
                                                              });
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .airplanemode_inactive,
                                                            color: Color(
                                                                0xFF363062),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
