import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/logoutButton.dart';
import '../components/submitButton.dart';
import '../constant/constants.dart';
import '../controller/bookmarkController.dart';
import '../controller/post_controller.dart';
import '../model/Ingredients.list.dart';
import '../model/post.dart';
import '../model/user.dart';
import '../model/userPost.dart';
import 'EditProfile.dart';
import 'detail_page.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import 'login_page2.dart';

enum postFilter {
  ALL,
  food,
  sweet,
  drink,
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);
  @override
  State<ListPage> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  List<UserPost> posts = [];
  List<UserPost> newPosts = [];
  List<String> selectedChips = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _caloriesController =
      TextEditingController(); // Added for calories input
  List<UserPost> _split = [];
  List<IngredientList> _searchResults = [];
  List<IngredientList> IGDResults = [];
  List<IngredientList> _selectedIngredients = [];
  int? userId;
  String? userName;
  String? userEmail;
  String? userImage;
  String? userType;

  Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(LoginScreen());
  }

  Future<void> _printUserIdFromToken(String token) async {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = int.tryParse(decodedToken['user_id'].toString());
      // userName = decodedToken['user_name'];
      //userEmail = decodedToken['user_email'];
      userImage = decodedToken['user_image'];
      userType = decodedToken['user_type'];
      // print(userId);
      // print(userName);
      // print(userEmail);
      // print(userImage);
      // print(userType);

      // เรียกดึงข้อมูลผู้ใช้
      //await getUser();
    } catch (error) {
      print('Error decoding token: $error');
    }
  }

  Future<void> getUser() async {
    var url = Uri.parse("http://10.0.2.2:4000/login");
    var response = await http.get(url);
    var users = userFromJson(response.body);

    // หา username ที่มี user_id ตรงกับของ token
    var userWithMatchingId = users.firstWhere((user) => user.userId == userId);
    //users = users.where((element) => element.userId == userId).toList();
    //print(users);
    print("User with matching ID: ${userWithMatchingId.userName}");
    userName = userWithMatchingId.userName;
    userEmail = userWithMatchingId.userEmail;
  }

  // get teams
  Future getPost() async {
    var url = Uri.parse("http://10.0.2.2:4000/post_data");
    var response = await http.get(url);
    posts = userPostFromJson(response.body);

    setState(() {
      newPosts = posts;
      newPosts.forEach((element) {
        imagesUrl.add(element.postImage);
      });
    });
  }

  List imagesUrl = [];

  void updateposts() {
    setState(() {
      if (selectedChips.isEmpty) {
        newPosts = posts;
      } else {
        newPosts = posts.where((result) {
          return selectedChips.any((chip) => result.ingredientsId
                  .map((ingredient) => ingredient.ingredientsName)
                  .contains(chip)) ||
              selectedChips.any((chip) => result.postTypes.contains(chip));
        }).toList();
      }
    });
  }

  void _toggleChip(String chipLabel) {
    setState(() {
      if (selectedChips.contains(chipLabel)) {
        selectedChips.remove(chipLabel);
      } else {
        selectedChips.add(chipLabel);
      }
      updateposts();
    });
  }

  Future getIGD() async {
    var url = Uri.parse("http://10.0.2.2:4000/ingredients_data");
    var response = await http.get(url);
    IGDResults = ingredientListFromJson(response.body);

    setState(() {
      _searchResults = IGDResults.where((result) =>
          result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) &&
          !_selectedIngredients.contains(result)).toList();
    });
  }

  _onSearchChanged() {
    setState(() {
      _searchResults = IGDResults.where(
          (result) => result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              )).toList();
    });
  }

  void _onIngredientRemoved(IngredientList ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
      _searchResults = IGDResults.where((result) =>
          result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) &&
          !_selectedIngredients.contains(result)).toList();
    });
  }

  void _refreshChoiceChips() {
    setState(() {
      _selectedIngredients.clear();
      selectedChips.clear();
      _searchResults = IGDResults.where(
          (result) => result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              )).toList();
    });
  }

  String? getUserNameFromToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String? userName = decodedToken['user_name'];
    return userName;
  }

  Future<void> fetchPosts() async {
    await getPost();
    // เรียกใช้เมื่อต้องการดึงข้อมูลโพสต์
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

  @override
  void initState() {
    super.initState();
    getIGD();
    getPost();
    getUser();
    SharedPreferences.getInstance().then((prefs) {
      final String? token = prefs.getString('token');
      if (token != null) {
        _printUserIdFromToken(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        //backgroundColor: Color.fromARGB(255, 245, 238, 255),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xff4D4C7D), // สีบน,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff363062),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // LogoutButton(
                        //   onPressed:
                        //   title: 'Log out',
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              Logout();
                            },
                            icon: Icon(
                              Icons.logout,
                              size: 35,
                              color: Colors.white,
                            )),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  userName: userName
                                      .toString(), // Pass the user_name to EditProfilePage
                                  userEmail: userEmail
                                      .toString(), // Pass the user_email to EditProfilePage
                                  userImage: userImage
                                      .toString(), // Pass the user_image to EditProfilePage
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFF99417),
                                width: 5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                //bottomLeft: Radius.circular(10.0)
                              ),
                              color: Color(0xFFF99417),
                            ),
                            padding: EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$userName',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '$userEmail',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userImage != null
                                      ? NetworkImage(
                                          'http://10.0.2.2:4000/uploadPostImage/$userImage',
                                        )
                                      : NetworkImage(
                                          'http://10.0.2.2:4000/uploadPostImage/coke.jpg'), // รูปภาพสำรอง
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: 'Enter a search term',
                          contentPadding: EdgeInsets.only(
                            left: 15.0,
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            newPosts = posts
                                .where((result) => result.postName
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                            _searchResults = IGDResults.where((result) => result
                                .ingredientsName
                                .toLowerCase()
                                .contains(query.toLowerCase())).toList();
                          });
                        },
                        controller: _searchController,
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    Container(
                      height: 35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _searchResults.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return IconButton(
                              onPressed: () {
                                _refreshChoiceChips();
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            final result = _searchResults[index - 1];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 18.0),
                                ChoiceChip(
                                  backgroundColor: Color(0xFF4D4C7D),
                                  key: ValueKey(result),
                                  label: Text(
                                    result.ingredientsName,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                  selected: selectedChips
                                      .contains(result.ingredientsName),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedChips
                                            .add(result.ingredientsName);
                                        _selectedIngredients.add(
                                            result); // ตรวจสอบการเพิ่ม ChoiceChip ลงใน _selectedIngredients
                                      } else {
                                        selectedChips
                                            .remove(result.ingredientsName);
                                        _selectedIngredients.remove(
                                            result); // ตรวจสอบการลบ ChoiceChip ออกจาก _selectedIngredients
                                      }
                                      updateposts();
                                    });
                                  },
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(height: 5.0),
                        const SizedBox(width: 18.0),
                        Text(
                          'TYPES',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Wrap(
                          children: [
                            FilterChip(
                              label: Text('food'),
                              selected: selectedChips.contains('food'),
                              onSelected: (_) => _toggleChip('food'),
                              selectedColor: Color(0xFFF99417),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            FilterChip(
                              label: Text('sweet'),
                              selected: selectedChips.contains('sweet'),
                              onSelected: (_) => _toggleChip('sweet'),
                              selectedColor: Color.fromARGB(255, 247, 154, 255),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            FilterChip(
                              label: Text('drink'),
                              selected: selectedChips.contains('drink'),
                              onSelected: (_) => _toggleChip('drink'),
                              selectedColor: Color.fromARGB(255, 109, 245, 255),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            // เพิ่ม Filter Chip
                          ],
                        ),

                        // Rest of your code...
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20.0,
                        ),
                        SizedBox(
                          width: 70,
                          height: 30,
                          child: TextField(
                            // For filtering by calories
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              // hintText: 'enter  ',
                              contentPadding: EdgeInsets.only(right: 5.0),
                            ),
                            textAlign: TextAlign.right,
                            onChanged: (query) {
                              if (int.tryParse(query) != null) {
                                setState(() {
                                  newPosts = posts
                                      .where((result) =>
                                          result.totalCal == null ||
                                          result.totalCal <= int.parse(query))
                                      .toList();
                                });
                              } else {
                                setState(() {
                                  newPosts = posts;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,
                            controller: _caloriesController,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            //textAlign: TextAlign.left,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  5), // จำกัดจำนวนตัวเลขให้มีไม่เกิน 4 หลัก
                            ],
                          ),
                        ),
                        Text(
                          '  KCAL',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Visibility(
                      visible: _selectedIngredients.isNotEmpty,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children:
                              _selectedIngredients.map((selectedIngredient) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Chip(
                                label: Text(
                                  selectedIngredient.ingredientsName,
                                  style: TextStyle(color: Color(0xFF363062)),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    _onIngredientRemoved(selectedIngredient);
                                    selectedChips.remove(selectedIngredient
                                        .ingredientsName); // ลบชื่ออาหารออกจาก selectedChips
                                    updateposts();
                                  });
                                },
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                          itemCount: newPosts.length,
                          padding: EdgeInsets.all(8),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var reverseindex = newPosts.length - 1 - index;
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
                                    onPressed: () async {
                                      final shouldRefreshData =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            userP: posts[reverseindex],
                                            post_id: posts[reverseindex].postId,
                                          ),
                                        ),
                                      );

                                      if (shouldRefreshData == true) {
                                        await getPost();
                                      }
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
                                                        'http://10.0.2.2:4000/uploadPostImage/${newPosts[reverseindex].postImage}',
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
                                                  "${newPosts[reverseindex].totalCal} KCAL",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '(' +
                                                          (newPosts[reverseindex]
                                                                      .averageScore ??
                                                                  '0')
                                                              .toString() +
                                                          ')', // ใช้ '0' หาก averageScore เป็น null
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    for (int i = 1; i <= 5; i++)
                                                      Icon(
                                                        Icons.star,
                                                        color: i <=
                                                                double.parse(newPosts[
                                                                            reverseindex]
                                                                        .averageScore ??
                                                                    '0') // แปลงเป็น double โดยใช้ double.parse
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                255,
                                                                203,
                                                                59)
                                                            : Colors.grey,
                                                        size: 12.0,
                                                      ),
                                                  ],
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // จัดเรียงข้อความด้านซ้าย
                                                children: [
                                                  Text(
                                                    newPosts[reverseindex]
                                                        .postName,
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
                                                        color:
                                                            Color(0xFF363062),
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
                                                      newPosts[reverseindex]
                                                          .userName,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF4D4C7D),
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left,
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
                                                    await BookmarkController()
                                                        .BookmarkUser(
                                                      newPosts[reverseindex]
                                                          .postId,
                                                    );
                                                    // await getBookmark();
                                                    // setState(() {
                                                    //   getPost(); // เรียกใช้งาน getPost() เพื่อรีเฟรชหน้าจอ
                                                    //   //getBookmark();
                                                    // });
                                                    Get.snackbar(
                                                      'สำเร็จ',
                                                      'เพิ่มลง Bookmarks ของคุณแล้ว',
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 255, 255),
                                                  ),
                                                  child: Icon(
                                                    Icons.bookmark_add_sharp,
                                                    color: Color(0xFF363062),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await PostController()
                                                        .ReportPost(
                                                      newPosts[reverseindex]
                                                          .postId,
                                                    );

                                                    Get.snackbar(
                                                      'Report สำเร็จ',
                                                      'ระบบได้ส่งคำร้องของคุณแล้ว',
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 255, 255),
                                                  ),
                                                  child: Icon(
                                                    Icons.report,
                                                    color: Color(0xFF363062),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: userType == "admin",
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (userType == "admin") {
                                                        // ตรวจสอบว่า user_type เป็น "admin" หรือไม่
                                                        bool confirmDelete =
                                                            await _showDeleteConfirmationDialog();
                                                        if (confirmDelete) {
                                                          await PostController()
                                                              .deletePost(posts[
                                                                      reverseindex]
                                                                  .postId);
                                                          setState(() {
                                                            getPost(); // เรียกใช้งาน getPost() เพื่อรีเฟรชหน้าจอ
                                                          });
                                                          Get.snackbar(
                                                            'สำเร็จ',
                                                            'ลบโพสน์ของ ${posts[reverseindex].userName} แล้ว',
                                                            snackPosition:
                                                                SnackPosition
                                                                    .TOP,
                                                          );
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .delete_forever_sharp,
                                                      color: Color(0xFF363062),
                                                    ),
                                                  ),
                                                )
                                              ],
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
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;

  StarRating(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            Icons.star,
            color: i <= rating ? Colors.yellow : Colors.grey,
            size: 10.0,
          ),
      ],
    );
  }
}
