// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  InputTextFieldWidget(this.textEditingController, this.hintText);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Color.fromARGB(255, 130, 80, 184)), // กำหนดเส้นขอบสีเทา
        borderRadius: BorderRadius.circular(10), // กำหนดรูปร่างขอบเขต
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
            fillColor: Color.fromARGB(255, 255, 255, 255),
            hintText: hintText,
            hintStyle: TextStyle(color: Color.fromARGB(255, 111, 111, 111)),
            contentPadding: EdgeInsets.all(15),
            focusColor: Color.fromARGB(255, 255, 255, 255),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
