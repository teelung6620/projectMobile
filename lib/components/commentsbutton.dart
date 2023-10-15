// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const CommentButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: []),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none)),
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(0xFF363062),
              )),
          onPressed: onPressed,
          child: Text(title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ))),
    );
  }
}
