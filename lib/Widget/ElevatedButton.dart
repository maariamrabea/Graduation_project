import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

class elevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const elevatedButton(
      {super.key,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(

      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
         backgroundColor: const Color(0xFF577C8E),
        minimumSize: Size(
            double.infinity, screenHeight * (40 / screenHeight)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ), child: Text (text,style: AppTextStyles.buttonn),
    );
  }
}
