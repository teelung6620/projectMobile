import 'package:flutter/material.dart';

import '../components/my_textfield.dart';
import '../components/my_textfield2.dart';

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);

  final postnameController = TextEditingController();
  final solutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          MyTextField2(
              controller: postnameController,
              hintText: 'name',
              obscureText: false),
          const SizedBox(height: 20),
          MyTextField2(
              controller: solutController,
              hintText: 'Solution',
              obscureText: false),
        ],
      ),
    ));
  }
}
