import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Search and Filter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> allResults = []; // รายการทั้งหมด
  List<dynamic> filteredResults = []; // รายการที่ถูกกรอง
  List<String> selectedChips = []; // ชิปที่ถูกเลือก
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchResults(); // เรียกข้อมูลเมื่อหน้าจอถูกโหลด
  }

  void fetchResults() async {
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
    if (response.statusCode == 200) {
      setState(() {
        allResults = json.decode(response.body);
        filteredResults = allResults;
      });
    }
  }

  void filterResults() {
    setState(() {
      if (selectedChips.isEmpty) {
        filteredResults = allResults;
      } else {
        filteredResults = allResults.where((result) {
          return selectedChips.any((chip) => result['categories'].contains(
              chip)); // 'categories' คือชื่อหนึ่งใน properties ของข้อมูลจาก API
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
      filterResults(); // เมื่อเลือก/ยกเลิกชิป จะกรองรายการใหม่
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ค้นหาและกรอง API')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  filteredResults = allResults
                      .where((result) => result['title']
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                });
              },
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหา...',
              ),
            ),
          ),
          Wrap(
            children: [
              FilterChip(
                label: Text('หมวดหมู่ 1'),
                selected: selectedChips.contains('หมวดหมู่ 1'),
                onSelected: (_) => _toggleChip('หมวดหมู่ 1'),
              ),
              FilterChip(
                label: Text('หมวดหมู่ 2'),
                selected: selectedChips.contains('หมวดหมู่ 2'),
                onSelected: (_) => _toggleChip('หมวดหมู่ 2'),
              ),
              // เพิ่ม Filter Chip อื่น ๆ ตามต้องการ
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredResults[index]['title']),
                  subtitle: Text(filteredResults[index]['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
