import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_mobile/components/my_button.dart';
import 'package:project_mobile/pages/ADMINpages/addIGD.dart';
import 'package:project_mobile/pages/addPage.dart';
import 'package:project_mobile/pages/bookmarkPage.dart';
import 'package:project_mobile/pages/login_page.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:project_mobile/pages/register_page.dart';
import 'package:project_mobile/pages/yoursPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/auth_screen.dart';
import '../ListPage.dart';
import '../../components/my_textfield.dart';
import '../../constant/constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminPage extends StatefulWidget {
  final token;
  AdminPage({@required this.token, Key? key}) : super(key: key);
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _selectedIndex = 0;

  // void _navigateBottomBar(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  final List<Widget> _pages = [
    ListPage(),
    AddPage(),
    BookPage(),
    YourPages(),
    AddIGDPage()
  ];
  void _navigateBottomBar(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(actions: [
      //   TextButton(
      //       onPressed: () async {
      //         final SharedPreferences? prefs = await _prefs;
      //         prefs?.clear();
      //         Get.offAll(LoginScreen());
      //       },
      //       child: Text(
      //         'logout',
      //         style: TextStyle(color: Colors.white),
      //       ))
      // ]),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Image.asset("lib/assets/logoNew.png", width: 50),
      //   toolbarHeight: 60,
      //   backgroundColor: const Color.fromARGB(255, 182, 150, 239),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(Icons.search,
      //           color: Color.fromARGB(255, 255, 255, 255)),
      //       onPressed: () {
      //         showSearch(context: context, delegate: MySearchDelegate());
      //       },
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.person,
      //           color: Color.fromARGB(255, 255, 255, 255)),
      //       onPressed: () {},
      //     )
      //   ],
      // ),
      // body: TextButton(
      //     onPressed: () async {
      //       final SharedPreferences? prefs = await _prefs;
      //       print(prefs?.get('token'));
      //     },
      //     child: Text('print token'))

      // body: TextButton(
      //     onPressed: () async {
      //       final SharedPreferences? prefs = await _prefs;
      //       print(prefs?.get('token'));
      //     },
      //     child: Text('print token')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF363062),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFF8080A8),
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Admin',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Yours'),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'IGD'),
        ],
      ),
    );
  }
}

//search
// class MySearchDelegate extends SearchDelegate {
//   List<String> searchTerms = ['Fish', 'Pork', 'Chicken', 'meat'];
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.close),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () => close(context, null),
//       );

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var food in searchTerms) {
//       if (food.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(food);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var food in searchTerms) {
//       if (food.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(food);
//       }
//     }
//     return Container(
//       color: Color.fromARGB(255, 210, 193, 241),
//       child: ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(title: Text(result));
//         },
//       ),
//     );
//   }
// }
