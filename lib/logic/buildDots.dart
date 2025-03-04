import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildDots(int _currentPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
          (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: _currentPage == index ? 16 : 8,
        decoration: BoxDecoration(
          color: _currentPage == index ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}
