import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  // Future<String> fetchDataFromApi() async {
  //   var url = Uri.parse("http://10.0.2.2:4000/updatePostImage");

  //   var jsonData = await http.get(url);
  //   var fetchData = jsonDecode(jsonData.body);
  //   setState(() {
  //     newPosts = fetchData;
  //     newPosts.forEach((element) {
  //       imagesUrl.add(element.postImage);
  //     });
  //   });
  //   return "Success";
  // }

  // void updateposts(String value) {
  //   setState(() {
  //     if (value.isEmpty) {
  //       newPosts = posts;
  //     } else {
  //       newPosts = posts
  //           .where((element) => element.postName
  //               .toLowerCase()
  //               .contains(value.toLowerCase())&& (selectedChips == 'All' ||postFilter.all == selectedChips))
  //           .toList();
  //     }
  //   });
  //   return;
  // }
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
      updateposts(); // เมื่อเลือก/ยกเลิกชิป จะกรองรายการใหม่
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

      _searchResults = IGDResults.where(
          (result) => result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              )).toList();

      // อัปเดตรายการ ingredientsIdList
      // postController.ingredientsIdList = _selectedIngredients;
    });
  }

  @override
  void initState() {
    super.initState();
    getIGD();
    getPost();
  }

  //--------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 238, 255),
        body: Column(
          children: [
            SubmitButton(
              onPressed: () //=> postController.postMenuUser(),
                  {
                Logout();
              },
              title: 'Log out',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: 'Enter a search term',
                    contentPadding: EdgeInsets.only(
                      left: 15.0,
                    )),
                onChanged: (query) {
                  setState(() {
                    newPosts = posts
                        .where((result) => result.postName
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();

                    // เพิ่มส่วนนี้เพื่อกรอง ChoiceChip
                    _searchResults = IGDResults.where((result) =>
                        result.ingredientsName
                            .toLowerCase()
                            .contains(query.toLowerCase()) &&
                        !_selectedIngredients.contains(result)).toList();
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

            Visibility(
              visible: _selectedIngredients.isNotEmpty,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(255, 130, 80, 184),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
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
              ],
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
                        shrinkWrap:
                            true, // สำคัญ: คำสั่งนี้ช่วยให้ ListView.builder สามารถทำงานร่วมกับ SingleChildScrollView ได้
                        itemCount: newPosts.length,
                        padding: EdgeInsets.all(8),
                        physics:
                            NeverScrollableScrollPhysics(), // ยกเลิกการเลื่อนเพิ่มเติมสำหรับ ListView นี้
                        itemBuilder: (context, index) {
                          var reverseindex = newPosts.length - 1 - index;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 20,
                              height: 80,
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
                                child: Align(
                                  child: ListTile(
                                    subtitleTextStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                    titleTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                    leading: Image(
                                      image: NetworkImage(
                                        'http://10.0.2.2:4000/uploadPostImage/${newPosts[reverseindex].postImage}',
                                      ),
                                    ),
                                    title: Text(
                                      newPosts[reverseindex].postName,
                                      textAlign: TextAlign.right,
                                    ),
                                    subtitle: Text(
                                      newPosts[reverseindex].userName,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
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
