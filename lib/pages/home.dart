import 'package:flutter/material.dart';
import 'package:project_mobile/components/my_button.dart';
import 'package:project_mobile/pages/addPage.dart';
import 'package:project_mobile/pages/bookmarkPage.dart';
import 'package:project_mobile/pages/login_page.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:project_mobile/pages/register_page.dart';
import 'package:project_mobile/pages/yoursPage.dart';
import '../components/ListScalePage.dart';
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

  final List<Widget> _pages = [
    ListScalePage(),
    AddPage(),
    Bookmark(),
    YoursPage()
  ];

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    // final double categoryHeight = size.height * 0.30;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset("lib/assets/logoNew.png", width: 50),
        toolbarHeight: 60,
        backgroundColor: const Color.fromARGB(255, 182, 150, 239),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {},
          )
        ],
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_outlined), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline), label: 'Book'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined), label: 'Yours'),
        ],
      ),

      // body: Container(
      //   height: size.height,
      //   child: Column(
      //     children: <Widget>[
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       AnimatedOpacity(
      //         duration: const Duration(milliseconds: 200),
      //         opacity: closeTopContainer ? 0 : 1,
      //         child: AnimatedContainer(
      //             duration: const Duration(milliseconds: 200),
      //             width: size.width,
      //             alignment: Alignment.topCenter,
      //             height: closeTopContainer ? 0 : categoryHeight,
      //             child: categoriesScroller),
      //       ),
      //       Expanded(
      //           child: ListView.builder(
      //               controller: controller,
      //               itemCount: itemsData.length,
      //               physics: BouncingScrollPhysics(),
      //               itemBuilder: (context, index) {
      //                 double scale = 1.0;
      //                 if (topContainer > 0.5) {
      //                   scale = index + 0.5 - topContainer;
      //                   if (scale < 0) {
      //                     scale = 0;
      //                   } else if (scale > 1) {
      //                     scale = 1;
      //                   }
      //                 }
      //                 return Opacity(
      //                   opacity: scale,
      //                   child: Transform(
      //                     transform: Matrix4.identity()..scale(scale, scale),
      //                     alignment: Alignment.bottomCenter,
      //                     child: Align(
      //                         heightFactor: 0.7,
      //                         alignment: Alignment.topCenter,
      //                         child: itemsData[index]),
      //                   ),
      //                 );
      //               })),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: const BottomBar(),
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
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    );
  }
}

// class CategoriesScroller extends StatelessWidget {
//   const CategoriesScroller();

//   @override
//   Widget build(BuildContext context) {
//     final double categoryHeight =
//         MediaQuery.of(context).size.height * 0.30 - 50;
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: FittedBox(
//           fit: BoxFit.fill,
//           alignment: Alignment.topCenter,
//           child: Row(
//             children: <Widget>[
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.orange.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const <Widget>[
//                       Text(
//                         "อาหาร",
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.blue.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const <Widget>[
//                         Text(
//                           "เครื่องดื่ม",
//                           style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           "20 Items",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 239, 147, 251),
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const <Widget>[
//                       Text(
//                         "ขนมหวาน",
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
