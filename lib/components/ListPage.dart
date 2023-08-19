import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constant/constants.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);
  @override
  State<ListPage> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  final List<String> categories = ['food', 'sweet', 'drink'];

  List<String> selectedType = [];

  @override
  Widget build(BuildContext context) {
    final filterFoods = FoodList.where(
      (product) {
        return selectedType.isEmpty || selectedType.contains(product.type);
      },
    ).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories
                  .map(
                    (type) => FilterChip(
                        selected: selectedType.contains(type),
                        label: Text(type),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedType.add(type);
                            } else {
                              selectedType.remove(type);
                            }
                          });
                        }),
                  )
                  .toList(),
              // children: <Widget>[
              //   Container(
              //     width: 150,
              //     margin: EdgeInsets.only(right: 20),
              //     height: categoryHeight,
              //     decoration: BoxDecoration(
              //         color: Colors.orange.shade400,
              //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: const <Widget>[
              //           Text(
              //             "อาหาร",
              //             style: TextStyle(
              //                 fontSize: 25,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   Container(
              //     width: 150,
              //     margin: EdgeInsets.only(right: 20),
              //     height: categoryHeight,
              //     decoration: BoxDecoration(
              //         color: Colors.blue.shade400,
              //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
              //     child: Container(
              //       child: Padding(
              //         padding: const EdgeInsets.all(12.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: const <Widget>[
              //             Text(
              //               "เครื่องดื่ม",
              //               style: TextStyle(
              //                   fontSize: 25,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              //   Container(
              //     width: 150,
              //     margin: EdgeInsets.only(right: 20),
              //     height: categoryHeight,
              //     decoration: BoxDecoration(
              //         color: Color.fromARGB(255, 239, 147, 251),
              //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: const <Widget>[
              //           Text(
              //             "ขนมหวาน",
              //             style: TextStyle(
              //                 fontSize: 25,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterFoods.length,
              itemBuilder: (context, index) {
                final product = filterFoods[index];
                return Card(
                  elevation: 10.0,
                  margin: const EdgeInsets.all(8.2),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 137, 107, 243),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10, vertical: 10),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        product.type,
                        style: const TextStyle(
                            color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
