import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search and Select Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchAndSelectScreen(),
    );
  }
}

class Item {
  final String name;
  final String category;
  bool isSelected;

  Item(this.name, this.category, this.isSelected);
}

class SearchAndSelectScreen extends StatefulWidget {
  @override
  _SearchAndSelectScreenState createState() => _SearchAndSelectScreenState();
}

class _SearchAndSelectScreenState extends State<SearchAndSelectScreen> {
  List<Item> allItems = [
    Item('Apple', 'Fruits', false),
    Item('Banana', 'Fruits', false),
    Item('Carrot', 'Vegetables', false),
    Item('Date', 'Fruits', false),
    Item('Eggplant', 'Vegetables', false),
    // Add more items here...
  ];

  List<Item> displayedItems = [];

  String searchText = '';
  String selectedCategory = 'All'; // Default selected category

  @override
  void initState() {
    displayedItems = allItems;
    super.initState();
  }

  void updateDisplayedItems(String query) {
    setState(() {
      displayedItems = allItems
          .where((item) => (item.name
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
              (selectedCategory == 'All' || item.category == selectedCategory)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search and Select Example'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
                updateDisplayedItems(searchText);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue!;
                updateDisplayedItems(searchText);
              });
            },
            items:
                ['All', 'Fruits', 'Vegetables'] // Add more categories here...
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
                return CheckboxListTile(
                  title: Text(displayedItems[index].name),
                  subtitle: Text(displayedItems[index].category),
                  value: displayedItems[index].isSelected,
                  onChanged: (value) {
                    setState(() {
                      displayedItems[index].isSelected = value!;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
