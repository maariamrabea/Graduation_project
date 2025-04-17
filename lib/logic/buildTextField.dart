import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTextField({required String hint,required Controller ,required bool ispassword}) {
  return TextField(
    controller: Controller,
    obscureText: ispassword,
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
