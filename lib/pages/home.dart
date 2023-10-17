import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_mobile/components/my_button.dart';
import 'package:project_mobile/pages/addPage.dart';
import 'package:project_mobile/pages/bookmarkPage.dart';
import 'package:project_mobile/pages/login_page.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:project_mobile/pages/register_page.dart';
import 'package:project_mobile/pages/yoursPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_screen.dart';
import 'ListPage.dart';
import '../components/my_textfield.dart';
import '../constant/constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  final token;
  HomePage({@required this.token, Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [ListPage(), AddPage(), BookPage(), YourPages()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
