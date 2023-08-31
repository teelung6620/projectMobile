import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constant/constants.dart';
import '../model/post.dart';
import '../model/userPost.dart';
import '../pages/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);
  @override
  State<ListPage> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  List<UserPost> posts = [];
  List<UserPost> newPosts = [];
  String searchText = '';
  String selectedChips = 'All';

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

  void updateposts(String value) {
    setState(() {
      if (value.isEmpty) {
        newPosts = posts;
      } else {
        newPosts = posts
            .where((element) => element.postName
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }
    });
    return;
  }

  //--------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
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
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                  updateposts(value);
                },
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                      child: ListTile(
                        subtitleTextStyle: TextStyle(),
                        titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: Checkbox.width,
                            fontWeight: FontWeight.normal),
                        title: Text(newPosts[index].postName),
                        // subtitle: Text(newPosts[index].postTypes),
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
