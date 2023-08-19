import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constant/constants.dart';
import '../pages/home.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);
  @override
  State<ListPage> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  @override
  String searchText = '';
  String selectedCategory = 'All';
  List<Product> displayedItems = [];

  @override
  void initState() {
    displayedItems = FoodList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void updateDisplayedItems(String query) {
      setState(() {
        displayedItems = FoodList.where((item) => (item.name
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                (selectedCategory == 'All' || item.type == selectedCategory)))
            .toList();
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 226, 255),
        body: Column(
          children: <Widget>[
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
                  updateDisplayedItems(searchText);
                },
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            DropdownButton<String>(
              iconEnabledColor: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              dropdownColor: Colors.white,
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  updateDisplayedItems(searchText);
                });
              },
              items: [
                'All',
                'food',
                'sweet',
                'drink'
              ] // Add more categories here...
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: displayedItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.all(7.2),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(73, 255, 255, 255)),
                      child: CheckboxListTile(
                        title: Text(displayedItems[index].name),
                        subtitle: Text(displayedItems[index].type),
                        value: displayedItems[index].isSelected,
                        onChanged: (value) {
                          setState(() {
                            displayedItems[index].isSelected = value!;
                          });
                        },
                      ),
                    ),
                  );
                  // return Card(
                  //   elevation: 10.0,
                  //   margin: const EdgeInsets.all(8.2),
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       color: Color.fromARGB(255, 137, 107, 243),
                  //     ),
                  //     child: ListTile(
                  //       contentPadding: const EdgeInsetsDirectional.symmetric(
                  //           horizontal: 10, vertical: 10),
                  //       title: Text(
                  //         FoodList[index].name,
                  //         style: const TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 18),
                  //       ),
                  //       subtitle: Text(
                  //         FoodList[index].type,
                  //         style: const TextStyle(
                  //             color: Colors.white, fontStyle: FontStyle.italic),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
