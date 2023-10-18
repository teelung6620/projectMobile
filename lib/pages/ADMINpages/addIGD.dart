import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/IGDadd.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/BookMark.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../components/input_textfield.dart';
import '../../components/submitButton.dart';

class AddIGDPage extends StatefulWidget {
  AddIGDPage({Key? key}) : super(key: key);
  @override
  State<AddIGDPage> createState() => _AddIGDState();
}

class _AddIGDState extends State<AddIGDPage> {
  IGDController igdController = Get.put(IGDController());
  String _selectedItem = 'กรัม';
  List<String> unitNameOptions = ['กรัม', 'ฟอง', 'ช้อนชา', 'ถ้วย'];
  List<IngredientList> IGDResults = [];
  TextEditingController _searchController = TextEditingController();
  List<IngredientList> _searchResults = [];
  Future getIGD() async {
    var url = Uri.parse("http://10.0.2.2:4000/ingredients_data");
    var response = await http.get(url);
    IGDResults = ingredientListFromJson(response.body);

    setState(() {
      _searchResults = IGDResults.where((result) => result.ingredientsName
          .toLowerCase()
          .contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getIGD();
    //_selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF4D4C7D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromARGB(255, 63, 12, 124), // สีบน
                //     Color.fromARGB(255, 175, 110, 255), // สีล่าง
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: Color(0xFF363062),
                // border: Border.all(
                //   color: Colors.black, // สีขอบ
                //   width: 2.0, // ความหนาขอบ
                // ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0), // ความโค้งขอบ
                ),
              ),
              padding: EdgeInsets.all(20.0), // ความห่างระหว่างขอบและเนื้อหา

              child: Text(
                'ADD INGREDIENT',
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F5F5)),
              ),
            ),

            // MyTextField2(
            //     controller: postnameController,
            //     hintText: 'name',
            //     obscureText: false),
            // const SizedBox(height: 20),
            // MyTextField2(
            //     controller: DescriptController,
            //     hintText: 'Solution',
            //     obscureText: false),
            // const SizedBox(height: 20),

            PostWidget(),

            //_buildSearchResults(),
            SubmitButton(
              onPressed: () {
                if (igdController.nameController.text.isEmpty ||
                    igdController.unitController.text.isEmpty ||
                    igdController.unitNameController.text.isEmpty ||
                    igdController.calController.text.isEmpty) {
                  // แจ้งเตือนผู้ใช้ให้กรอกข้อมูลให้ครบถ้วน
                  Get.snackbar(
                    'แจ้งเตือน',
                    'กรุณากรอกข้อมูลให้ครบถ้วน',
                    snackPosition: SnackPosition.TOP,
                  );
                } else {
                  igdController.IGDadder();
                }
              },
              title: 'เพิ่ม',
            ),
          ],
        ),
      ),
    ));
  }

  Widget PostWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Center(
            child: InputTextFieldWidget(igdController.nameController, 'Name')),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              'ปริมาณ : ',
              style: TextStyle(fontSize: 18, color: Color(0xFFF5F5F5)),
            ),
            Center(
              child: SizedBox(
                width: 70,
                height: 30,
                child: TextField(
                  // For filtering by calories
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    // hintText: 'enter  ',
                    contentPadding: EdgeInsets.only(right: 5.0),
                  ),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  controller: igdController.unitController,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  //textAlign: TextAlign.left,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        5), // จำกัดจำนวนตัวเลขให้มีไม่เกิน 4 หลัก
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            // Center(
            //     child: InputTextFieldWidget(
            //         igdController.unitNameController, 'หน่วย')),
            Container(
              height: 30,
              decoration: BoxDecoration(
                  color: Color(0xFF363062),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    value: _selectedItem,
                    dropdownColor: Color(0xFF363062),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    iconEnabledColor: Colors.white,
                    items: unitNameOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem = newValue ?? '';
                        igdController.unitNameController.text = _selectedItem;
                      });
                    },
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              'แคลอรี่ : ',
              style: TextStyle(fontSize: 18, color: Color(0xFFF5F5F5)),
            ),
            Center(
              child: SizedBox(
                width: 70,
                height: 30,
                child: TextField(
                  // For filtering by calories
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    // hintText: 'enter  ',
                    contentPadding: EdgeInsets.only(right: 5.0),
                  ),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  controller: igdController.calController,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  //textAlign: TextAlign.left,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        5), // จำกัดจำนวนตัวเลขให้มีไม่เกิน 4 หลัก
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            // Center(
            //     child: InputTextFieldWidget(
            //         igdController.unitNameController, 'หน่วย')),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 147, 91, 251),
              ),
              hintText: 'ค้นหาส่วนผสมที่ต้องการ',
              contentPadding: EdgeInsets.only(
                left: 15.0,
              ),
            ),
            onChanged: (query) {
              setState(() {
                _searchResults = IGDResults.where((result) => result
                    .ingredientsName
                    .toLowerCase()
                    .contains(query.toLowerCase())).toList();
              });
            },
            controller: _searchController,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        Container(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults.reversed.toList()[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 18.0),
                  Chip(
                    backgroundColor: Color(0xFF363062),
                    key: ValueKey(result),
                    label: Text(
                      result.ingredientsName +
                          ' ' +
                          result.ingredientsUnits.toString() +
                          ' ' +
                          (ingredientsUnitsNameValues
                                  .reverse[result.ingredientsUnitsName] ??
                              '') +
                          ' ' +
                          result.ingredientsCal.toString() +
                          '  แคลอรี่',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
