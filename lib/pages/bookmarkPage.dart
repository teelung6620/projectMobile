import 'package:flutter/material.dart';

class Bookmark extends StatelessWidget {
  const Bookmark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Bookmark Page",
        style: TextStyle(fontSize: 50),
      ),
    );
  }
}
