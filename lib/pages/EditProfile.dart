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
import '../controller/bookmarkController.dart';
import '../controller/login_controller.dart';
import '../controller/registeration_controller.dart';
import '../model/userPost.dart';
import 'detail_page.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImage;
  EditProfilePage(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.userImage})
      : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePage> {
  List<UserPost> posts = [];
  List imagesUrl = [];
  List<BookMark> bookmark = [];
  int? userId;
  int? postId;
  TextEditingController userNameController = TextEditingController();
  LoginController patchController = Get.put(LoginController());

  Future getBookmark() async {
    var url = Uri.parse("http://10.0.2.2:4000/bookmarks");
    var response = await http.get(url);
    bookmark = bookMarkFromJson(response.body);

    // กรองเฉพาะโพสต์ที่มี user_id ตรงกับ userId
    bookmark = bookmark.where((element) => element.userId == userId).toList();
  }

  Future<void> loginUser() async {
    // โค้ดสำหรับล็อกอินของคุณ
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

      print(userId);

      // เรียกดึง bookmark และ post ในนี้หลังจากกำหนดค่า userId แล้ว
      // await getBookmark();
      // await getPost();
    } catch (error) {
      print('Error decoding token: $error');
    }
  }

  Future _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ Bookmark'),
          content: Text('คุณต้องการลบ Bookmark นี้ ใช่หรือไม่?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 108, 37, 207), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 108, 37, 207), // สีพื้นหลังของปุ่ม
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

  void saveUserName() async {
    // Get the token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      // Call the method to save the user name and email
      final LoginController loginController = Get.find();
      await loginController.patchUserData();

      // Optionally, you can show a confirmation or success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data updated successfully'),
        ),
      );
    } else {
      // Handle the case where token is null
    }
  }

  @override
  void initState() {
    super.initState();
    getBookmark();
    getPost();
    patchController.nameController.text = widget.userName;
    patchController.emailController.text = widget.userEmail;
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
        backgroundColor: Color.fromARGB(255, 63, 57, 109),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            (widget.userName),
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF363062),
          toolbarHeight: 60,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF363062),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0), // ความโค้งขอบ
                ),
              ),
              padding: EdgeInsets.all(20.0), // ความห่างระหว่างขอบและเนื้อหา

              child: TextField(
                controller: patchController.nameController,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF363062),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0), // ความโค้งขอบ
                ),
              ),
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: patchController.emailController,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the method to save the user name
                saveUserName();
                Navigator.pop(context, true); // ปิดหน้าปัจจุบัน
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
