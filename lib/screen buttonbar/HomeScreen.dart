import 'package:flutter/material.dart';

import '../homewidget/Middle_Bart.dart';
import '../homewidget/upper_part.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(top: screenHeight * (0 / screenHeight), child: UpperPart()),
        // SizedBox(height: 40),
        Positioned(
          top: screenHeight * (350 / screenHeight),
         // left: screenWidth * (16 / screenWidth),

          child: MiddleBart(),
        ),
      ],
    );
  }
}
