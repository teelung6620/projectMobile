import 'package:flutter/material.dart';

class MyTextField2 extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField2({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 102, 31, 243))),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            filled: true,
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 206, 206, 206))),
      ),
    );
  }
}
