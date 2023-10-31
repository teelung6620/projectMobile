// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputTextFieldMultipleWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;

  InputTextFieldMultipleWidget(this.textEditingController, this.hintText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10), // กำหนดระยะห่างรอบคอลัมน์
      margin: EdgeInsets.all(10), // กำหนดระยะห่างรอบแถว
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Color.fromARGB(255, 130, 80, 184)), // กำหนดเส้นขอบสีเทา
        borderRadius: BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 10,
        maxLines: 40,
        controller: textEditingController,
        decoration: new InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromARGB(255, 148, 148, 148)),
        ),
      ),
    );
  }
}
