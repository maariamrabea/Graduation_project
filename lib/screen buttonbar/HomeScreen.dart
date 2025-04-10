import 'package:flutter/material.dart';

import '../homewidget/Middle_Bart.dart';
import '../homewidget/endpart.dart';
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
    return
      Scaffold(body:

      SingleChildScrollView(
      child: Column(
        children: [
          Positioned(child: UpperPart()),
          Positioned(child: MiddleBart()),
          Positioned(child: EndBart()),
        ],
      ),),
    );
  }
}
