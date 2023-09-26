import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/pages/homeTest.dart';
import 'package:project_mobile/pages/login_page2.dart';
import 'package:project_mobile/pages/registTest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/input_textfield.dart';
import '../components/input_textfieldmultiple.dart';
import '../components/my_textfield.dart';
import '../components/my_textfield2.dart';
import 'package:http/http.dart' as http;

import '../components/submitButton.dart';
import '../controller/registeration_controller.dart';
import 'dart:io';

class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);
  @override
  State<AddPage> createState() => _AddState();
}

class _AddState extends State<AddPage> {
  PostController postController = Get.put(PostController());
  late int user_id;
  TextEditingController _searchController = TextEditingController();
  List<IngredientList> _searchResults = [];
  List<IngredientList> IGDResults = [];
  //List<IngredientList> _selectedResults = [];
  //bool _isSelected = false;
  List<IngredientList> _selectedIngredients = [];

  XFile? image;
  final picker = ImagePicker();

  Future getIGD() async {
    var url = Uri.parse("http://10.0.2.2:4000/ingredients_data");
    var response = await http.get(url);
    IGDResults = ingredientListFromJson(response.body);

    setState(() {
      _searchResults = IGDResults.where((result) =>
              result.ingredientsName.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ) &&
              !_selectedIngredients.contains(result))
          .toList(); // ตรวจสอบว่าไม่ถูกเลือกแล้วถึงเพิ่มลงใน _searchResults
    });
  }

  @override
  void initState() {
    super.initState();
    getIGD();
  }

  _onSearchChanged() {
    setState(() {
      _searchResults = IGDResults.where(
          (result) => result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              )).toList();
    });
  }

  void _onIngredientRemoved(IngredientList ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
      _searchResults = IGDResults.where((result) =>
          result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) &&
          !_selectedIngredients.contains(result)).toList();

      // อัปเดตรายการ ingredientsIdList
      postController.ingredientsIdList = _selectedIngredients;
    });
  }

  void _refreshChoiceChips() {
    setState(() {
      // รีเฟรช ChoiceChips โดยลบทุก Ingredient ออกจาก _selectedIngredients
      _selectedIngredients.clear();

      // รีเฟรชรายการที่แสดงใหม่โดยใช้เงื่อนไขเดียวกันกับการค้นหาเพื่อแสดงทุกอัน
      _searchResults = IGDResults.where(
          (result) => result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              )).toList();

      // อัปเดตรายการ ingredientsIdList
      postController.ingredientsIdList = _selectedIngredients;
    });
  }

  void submitPost() {
    // ตั้งค่าข้อความใน IGDController ขึ้นอยู่กับส่วนประกอบที่เลือก
    // คุณสามารถรวม ID ของส่วนประกอบที่เลือกเป็นสตริงที่คั่นด้วยจุลภาคเช่น 1,2,3
    postController.IGDController.text = _selectedIngredients
        .map((ingredient) => ingredient.ingredientsId.toString())
        .join(',');

    // เรียกใช้เมธอด postMenuUser เพื่อส่งข้อมูล
    postController.postMenuUser(image!.path);
  }

  _getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print(token);

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);

    user_id = jwtDecodedToken['user_id'];
    print(user_id);
  }

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // ทำสิ่งที่คุณต้องการกับรูปภาพที่เลือก
      // เช่น การแสดงรูปภาพในแอปหรือการอัปโหลดไปยังเซิร์ฟเวอร์ Node.js
    }
  }

  Future<void> uploadImage(String imagePath) async {
    final url = Uri.parse(
        'localhost:4000/uploadPostImage'); // เปลี่ยนเป็น URL ของเซิร์ฟเวอร์ Node.js

    var request = http.MultipartRequest('PATCH', url);
    request.files
        .add(await http.MultipartFile.fromPath('post_image', imagePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Upload success');
      } else {
        print('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 245, 238, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
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
                submitPost(); // เรียกใช้ submitPost เมื่อปุ่มส่งถูกกด
              },
              title: 'ส่งข้อมูล',
            ),
          ],
        ),
      ),
    ));
  }

  Widget PostWidget() {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                image = pickedFile;
              });
              // ทำอะไรกับ imagePath ต่อไป
            }
          },
          child: Text('choose image'),
        ),
        CircleAvatar(
          radius: 20,
          child: image != null
              ? Image.file(
                  File(image!.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับตัว widget
                )
              : null,
        ),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(postController.nameController, 'Name'),
        SizedBox(
          height: 20,
        ),
        Text('Ingredients'),
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
                color: Colors.black,
              ),
              hintText: 'Enter a search term',
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
          height: 35, // กำหนดความสูงของ ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _searchResults.length +
                1, // เพิ่ม 1 เพื่อให้มีปุ่ม "Refresh" ด้วย
            itemBuilder: (context, index) {
              if (index == 0) {
                // ใส่ปุ่ม "Refresh" ที่ index 0
                return IconButton(
                    onPressed: () {
                      _refreshChoiceChips();
                    },
                    icon: Icon(Icons.refresh));
              } else {
                final result = _searchResults[index - 1];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 18.0),
                    ChoiceChip(
                      backgroundColor: Color.fromARGB(255, 230, 210, 255),
                      key: ValueKey(result),
                      label: Text(
                        result.ingredientsName,
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      selected: _selectedIngredients.contains(result),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedIngredients.add(result);
                          } else {
                            _onIngredientRemoved(result);
                          }
                          _searchResults = IGDResults.where((result) =>
                              result.ingredientsName.toLowerCase().contains(
                                    _searchController.text.toLowerCase(),
                                  ) &&
                              !_selectedIngredients.contains(result)).toList();
                        });
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height:
                _selectedIngredients.length * 50.0, // กำหนดความสูงของ ListView
            child: ListView.builder(
              scrollDirection: Axis.vertical, // กำหนดเรียงแนวนอน
              itemCount: _selectedIngredients.length,
              itemBuilder: (context, index) {
                final selectedIngredient =
                    _selectedIngredients.elementAt(index);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 18.0),
                    Chip(
                      label: Text(selectedIngredient.ingredientsName),
                      backgroundColor: Colors.white,
                      onDeleted: () {
                        setState(() {
                          _selectedIngredients.remove(selectedIngredient);
                        });
                      },
                    ),
                    Text('   ' +
                        selectedIngredient.ingredientsUnits.toString() +
                        ' กรัม   '),
                    Text(selectedIngredient.ingredientsCal.toString() +
                        ' แคลลอรี่')
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          postController.typeController,
          'TYPES',
        ),
        InputTextFieldMultipleWidget(
          postController.descriptionController,
          'Description',
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
