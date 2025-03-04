import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const CustomIconButton({
    Key? key,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new, color: color),
      onPressed: onPressed,
    );
  }
}
