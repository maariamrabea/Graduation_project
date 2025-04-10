import 'package:flutter/material.dart';

import '../Widget/ElevatedButton.dart';
import '../onpording/Frist_Screen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return (Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("images/Background.png"),



    Elevated_Button(text: "Start", onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Frist_Screen()),
    );})

        ],
      ),
    ));
  }
}
