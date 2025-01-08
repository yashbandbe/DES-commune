// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField({
    required this.onEditingComplete,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onEditingComplete: () => onEditingComplete(controller.value.text),
        cursorColor: Colors.grey.shade400,
        style: TextStyle(color: Colors.black),
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade400,
          ),
        ));
  }
}
