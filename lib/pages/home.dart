import 'package:flutter/material.dart';
import 'package:project_mobile/components/my_button.dart';
import 'package:project_mobile/pages/addPage.dart';
import 'package:project_mobile/pages/bookmarkPage.dart';
import 'package:project_mobile/pages/login_page.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:project_mobile/pages/register_page.dart';
import 'package:project_mobile/pages/yoursPage.dart';
import '../components/ListPage.dart';
import '../components/my_textfield.dart';
import '../constant/constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [ListPage(), AddPage(), Bookmark(), YoursPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 182, 150, 239),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(179, 255, 255, 255),
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Yours'),
        ],
      ),
    );
  }
}

//search
class MySearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['Fish', 'Pork', 'Chicken', 'meat'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var food in searchTerms) {
      if (food.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(food);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var food in searchTerms) {
      if (food.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(food);
      }
    }
    return Container(
      color: Color.fromARGB(255, 210, 193, 241),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(title: Text(result));
        },
      ),
    );
  }
}
