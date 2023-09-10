import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constant/constants.dart';
import '../model/post.dart';
import '../model/userPost.dart';
import 'detail_page.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // get teams
  Future getPost() async {
    var url = Uri.parse("http://10.0.2.2:4000/post_data");
    var response = await http.get(url);
    posts = userPostFromJson(response.body);

    setState(() {
      newPosts = posts;
    });
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

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
          return selectedChips.any((chip) => result.postTypes.contains(chip));
        }).toList();
      }
    });
    return;
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

  //--------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 231, 215, 255),
        body: Column(
          children: [
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
                  });
                },
                controller: _searchController,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
              child: ListView.builder(
                itemCount: newPosts.length,
                padding: EdgeInsets.all(8),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 20,
                      height: 120,
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
                                      userP: posts[index],
                                    )),
                          );
                        },
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: ListTile(
                            subtitleTextStyle: TextStyle(),
                            titleTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.normal),
                            title: Text(newPosts[index].postName),
                            // subtitle: Text(newPosts[index].postTypes),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}