// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputTextFieldWidgetTiny extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType keyboardType;

  InputTextFieldWidgetTiny(
    this.textEditingController,
    this.keyboardType,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 50,
      child: TextField(
        controller: textEditingController,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            fillColor: Colors.white54,
            hintStyle: TextStyle(color: Color.fromARGB(255, 180, 143, 209)),
            contentPadding: EdgeInsets.all(15),
            focusColor: Colors.white60,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
