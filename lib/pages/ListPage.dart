import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/submitButton.dart';
import '../constant/constants.dart';
import '../model/Ingredients.list.dart';
import '../model/post.dart';
import '../model/userPost.dart';
import 'detail_page.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(LoginScreen());
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
              .contains(chip));
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

  @override
  void initState() {
    super.initState();
    getIGD();
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 238, 255),
        body: Column(
          children: [
            SubmitButton(
              onPressed: () {
                Logout();
              },
              title: 'Log out',
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
                      icon: Icon(Icons.refresh),
                    );
                  } else {
                    final result = _searchResults[index - 1];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 18.0),
                        ChoiceChip(
                          backgroundColor: Color.fromARGB(255, 230, 210, 255),
                          key: ValueKey(result),
                          label: Text(
                            result.ingredientsName,
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          selected:
                              selectedChips.contains(result.ingredientsName),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedChips.add(result.ingredientsName);
                                _selectedIngredients.add(
                                    result); // ตรวจสอบการเพิ่ม ChoiceChip ลงใน _selectedIngredients
                              } else {
                                selectedChips.remove(result.ingredientsName);
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
                  'filters',
                  style: textTheme.labelLarge,
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
                      selectedColor: Color.fromARGB(255, 214, 165, 255),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    FilterChip(
                      label: Text('sweet'),
                      selected: selectedChips.contains('sweet'),
                      onSelected: (_) => _toggleChip('sweet'),
                      selectedColor: Color.fromARGB(255, 214, 165, 255),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    FilterChip(
                      label: Text('drink'),
                      selected: selectedChips.contains('drink'),
                      onSelected: (_) => _toggleChip('drink'),
                      selectedColor: Color.fromARGB(255, 214, 165, 255),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    // เพิ่ม Filter Chip
                  ],
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
                                  result.totalCal! <= int.parse(query))
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
                  style: TextStyle(fontSize: 18),
                )
                // Rest of your code...
              ],
            ),

            Visibility(
              visible: _selectedIngredients.isNotEmpty,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  children: _selectedIngredients.map((selectedIngredient) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Chip(
                        label: Text(selectedIngredient.ingredientsName),
                        onDeleted: () {
                          setState(() {
                            _onIngredientRemoved(selectedIngredient);
                            selectedChips.remove(selectedIngredient
                                .ingredientsName); // ลบชื่ออาหารออกจาก selectedChips
                            updateposts();
                          });
                        },
                        backgroundColor: Color.fromARGB(255, 229, 156, 255),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Row(
            //   children: [
            //     SizedBox(
            //       width: 20,
            //     ),
            //     DropdownButton<String>(
            //       iconEnabledColor: Colors.white,
            //       borderRadius: BorderRadius.circular(25.0),
            //       dropdownColor: Colors.white,
            //       value: selectedCategory,
            //       onChanged: (newValue) {
            //         setState(() {
            //           chipupdateposts(searchText);
            //         });
            //       },
            //       items: [
            //         'All',
            //         'food',
            //         'sweet',s
            //         'drink'
            //       ] // Add more categories here...
            //           .map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //     ),
            //   ],
            // ),
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
                                                    newPosts[reverseindex]
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
