import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project_mobile/controller/post_controller.dart';
import 'package:project_mobile/model/Ingredients.list.dart';
import 'package:project_mobile/model/user.dart';

import 'package:project_mobile/pages/ListPage.dart';
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
  int? user_id;
  int? banned;
  TextEditingController _searchController = TextEditingController();
  List<IngredientList> _searchResults = [];
  List<IngredientList> IGDResults = [];
  //List<IngredientList> _selectedResults = [];
  //bool _isSelected = false;
  List<IngredientList> _selectedIngredients = [];
  List<int> _selectedUnits = [];
  TextEditingController unitController = TextEditingController();
  List<String> typeOptions = ['food', 'sweet', 'drink'];
  String _selectedItem = 'food';
  List<User> UserResults = [];

  XFile? image;
  final picker = ImagePicker();

  _getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print(token);

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);

    user_id = jwtDecodedToken['user_id'];
    banned = jwtDecodedToken['banned'];
    print(user_id);
    print(banned);
  }

  Future<void> _checkUserStatus() async {
    // เรียก API หรือดึงข้อมูลผู้ใช้เพื่อตรวจสอบสถานะ banned
    // ตรวจสอบสถานะ banned ของผู้ใช้โดยใช้ค่าที่ได้จาก API หรือข้อมูลผู้ใช้

    var url = Uri.parse("http://10.0.2.2:4000/login");
    var response = await http.get(url);
    List<User> userResults = userFromJson(response.body);

    if (userResults.isNotEmpty) {
      bool isBanned = banned == 1; // เช็คว่า banned เป็น 1 หรือไม่

      if (isBanned) {
        // ถ้าผู้ใช้ถูกแบน
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('แจ้งเตือน'),
              content: Text('คุณถูกแบนและไม่สามารถใช้หน้านี้ได้'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 103, 23, 173),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Navigator.pop(context, '/ListPage');
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future getIGD() async {
    var url = Uri.parse("http://10.0.2.2:4000/ingredients_data");
    var response = await http.get(url);
    IGDResults = ingredientListFromJson(response.body);

    setState(() {
      _searchResults = IGDResults.where((result) =>
          result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) &&
          !_selectedIngredients.contains(result)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getIGD();
    _selectedItem;

    // เรียกฟังก์ชัน _checkUserStatus สำหรับตรวจสอบสถานะ banned
    _checkUserStatus();
    _getSavedToken();
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
      _selectedIngredients.clear();

      _searchResults = IGDResults.where(
          (result) => result.ingredientsName.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              )).toList();

      // อัปเดตรายการ ingredientsIdList
      postController.ingredientsIdList = _selectedIngredients;
    });
  }

  void submitPost() {
    if (image == null ||
        postController.nameController.text.isEmpty ||
        _selectedIngredients.isEmpty ||
        postController.typeController.text.isEmpty ||
        postController.descriptionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('แจ้งเตือน'),
            content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'OK',
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF363062)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    postController.IGDController.text = _selectedIngredients
        .map((ingredient) => ingredient.ingredientsId.toString())
        .join(',');

    postController.postMenuUser(image!.path, _selectedUnits);
  }

  // _getSavedToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("token");
  //   print(token);

  //   Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);

  //   user_id = jwtDecodedToken['user_id'];
  //   print(user_id);
  // }

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }

  // Future<void> uploadImage(String imagePath) async {
  //   final url = Uri.parse(
  //       'localhost:4000/uploadPostImage');

  //   var request = http.MultipartRequest('PATCH', url);
  //   request.files
  //       .add(await http.MultipartFile.fromPath('post_image', imagePath));

  //   try {
  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       print('Upload success');
  //     } else {
  //       print('Upload failed with status ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Upload failed: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 245, 238, 255),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff4D4C7D),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Visibility(
                  visible: banned == 1,
                  child: Column(
                    children: [
                      Text(
                        'คุณถูกแบน',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                      Text(
                        'คุณไม่สามารถเผยแพร่เมนูอาหารได้',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                    ],
                  )),
              const SizedBox(height: 30),
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

              Visibility(
                visible: banned == 0,
                child: SubmitButton(
                  onPressed: () {
                    submitPost();
                  },
                  title: 'CREATE',
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget PostWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            chooseImage();
          },
          child: Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: image != null
                  ? Image.file(
                      File(image!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Align(
                      alignment: Alignment.center, // จัดให้ Text อยู่ตรงกลาง
                      child: Text(
                        'เลือกรูปภาพของคุณ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(
                                0xFF363062)), // ปรับแต่งขนาดตัวอักษรตามที่คุณต้องการ
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
            child: InputTextFieldWidget(postController.nameController, 'Name')),
        SizedBox(
          height: 20,
        ),
        Text(
          '   ส่วนผสม',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
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
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _searchResults.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
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
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      key: ValueKey(result),
                      label: Text(
                        result.ingredientsName,
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      selected: _selectedIngredients.contains(result),
                      onSelected: (selected) {
                        if (selected) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              unitController.text =
                                  result.ingredientsUnits.toString();
                              return AlertDialog(
                                title: Text(result.ingredientsName),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextField(
                                            controller: unitController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ingredientsUnitsNameValues.reverse[
                                                  result
                                                      .ingredientsUnitsName] ??
                                              '' +
                                                  ' ' +
                                                  result.ingredientsUnits
                                                      .toString(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      child: Text("Add"),
                                      onPressed: () {
                                        int units =
                                            int.tryParse(unitController.text) ??
                                                0;
                                        if (units > 0) {
                                          setState(() {
                                            _selectedIngredients.add(result);
                                            _selectedUnits.add(units);
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Color(0xFF363062),
                                        ),
                                      )),
                                ],
                              );
                            },
                          );
                        } else {
                          _onIngredientRemoved(result);
                        }
                      },
                    )
                  ],
                );
              }
            },
          ),
        ),
        Visibility(
          visible: _selectedIngredients.isNotEmpty,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromARGB(255, 130, 80, 184),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: _selectedIngredients.map((selectedIngredient) {
                  final index =
                      _selectedIngredients.indexOf(selectedIngredient);
                  return Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Chip(
                              label: Text(selectedIngredient.ingredientsName),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  unitController.text + '  ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  ingredientsUnitsNameValues.reverse[
                                          selectedIngredient
                                              .ingredientsUnitsName] ??
                                      '' +
                                          ' ' +
                                          selectedIngredient.ingredientsUnits
                                              .toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '  ' +
                                      (int.parse(unitController.text) *
                                              selectedIngredient
                                                  .ingredientsCal ~/
                                              selectedIngredient
                                                  .ingredientsUnits)
                                          .toString() +
                                      ' แคลอรี่',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _selectedIngredients
                                      .remove(selectedIngredient);
                                  _selectedUnits.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              '  ประเภทของอาหาร : ',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 17),
            ),
            Container(
              height: 25,
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
                    items: typeOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem = newValue ?? '';
                        postController.typeController.text = _selectedItem;
                      });
                    },
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        InputTextFieldMultipleWidget(
          postController.descriptionController,
          'Description',
        ),
      ],
    );
  }
}
