// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputTextFieldMultipleWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  InputTextFieldMultipleWidget(this.textEditingController, this.hintText);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 15,
        controller: textEditingController,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            fillColor: Colors.white54,
            hintText: hintText,
            hintStyle: TextStyle(color: Color.fromARGB(255, 180, 143, 209)),
            contentPadding: EdgeInsets.symmetric(vertical: 200),
            focusColor: Colors.white60,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
