import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTextField({required String hint, bool isPassword = false}) {
  return TextField(
    obscureText: isPassword,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
  );
}
