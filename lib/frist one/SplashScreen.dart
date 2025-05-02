import 'package:flutter/material.dart';

import '../onpording/Frist_Screen.dart';
import '../registration/afterscreen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return (Scaffold(
      backgroundColor: Color(0xFF577C8E),
      body: Center(child:GestureDetector(
        onTap: () {
          print("Image clicked!");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Frist_Screen()),
          );
        },
        child: Image.asset('images/photo_2025-04-21_14-45-23 1.png'),
      )),
    ));
  }
}
