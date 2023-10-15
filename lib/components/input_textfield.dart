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
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 255, 255, 255))),
            fillColor: Color.fromARGB(255, 255, 255, 255),
            hintText: hintText,
            hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            contentPadding: EdgeInsets.all(15),
            focusColor: Color.fromARGB(255, 255, 255, 255),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
