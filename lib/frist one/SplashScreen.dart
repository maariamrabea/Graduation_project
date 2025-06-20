import 'package:flutter/material.dart';

import '../fontstyle.dart';
import '../onpording/Frist_Screen.dart';
class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
   // double screenWidth = MediaQuery.of(context).size.width;
   // double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsApp.color1,
      body: GestureDetector(
        onTap: () {
          print("Image clicked!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Frist_Screen()),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/Skinly.png'),

            ],
          ),
        ),
      ),
    );
  }
}