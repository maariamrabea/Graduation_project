import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

class Elevated_Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const Elevated_Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF577C8E),
        minimumSize: Size(double.infinity, screenHeight * (40 / screenHeight)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: AppTextStyles.f18.copyWith(color: Colors.white)),
    );
  }
}
