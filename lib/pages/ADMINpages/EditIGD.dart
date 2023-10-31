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

class EditIGDPage extends StatefulWidget {
  final String ingredientsName;
  final int ingredientsUnits;
  final IngredientsUnitsName ingredientsUnitsName;
  final int ingredientsCal;
  final int ingredientsId;
  EditIGDPage({
    Key? key,
    required this.ingredientsName,
    required this.ingredientsUnits,
    required this.ingredientsUnitsName,
    required this.ingredientsCal,
    required this.ingredientsId,
  }) : super(
          key: key,
        );
  @override
  State<EditIGDPage> createState() => _EditIGDState();
}

class _EditIGDState extends State<EditIGDPage> {
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

  Future _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการเปลี่ยนแปลง'),
          content: Text('คุณต้องการเปลี่ยนแปลงข้อมูลนี้ ใช่หรือไม่?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 108, 37, 207), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // ยกเลิกการลบ
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 108, 37, 207), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                igdController.patchIGD(widget.ingredientsId);

                // if (image != null) {
                //   saveUserImage();
                // }
                Navigator.of(context).pop(true); // ยืนยันการลบ
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    igdController.nameController.text = widget.ingredientsName;
    igdController.unitController.text = widget.ingredientsUnits.toString();
    igdController.unitNameController.text = _selectedItem;
    igdController.calController.text = widget.ingredientsCal.toString();
    getIGD();
    // _selectedItem = igdController.unitNameController.text;
    //_selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF4D4C7D),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'แก้ไขส่วนผสม',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF363062),
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 10,
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
                  // Call the method to save the user name
                  _showDeleteConfirmationDialog();
                },
                title: 'SAVE'),
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
      ],
    );
  }
}
