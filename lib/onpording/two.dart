import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/logic/buildDots.dart';
import 'package:graduationproject/onpording/three.dart';
import 'package:graduationproject/registration/afterscreen.dart';

class Screen2 extends StatelessWidget {
  final int currentPage;

  const Screen2({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return (Scaffold(
      backgroundColor: const Color(0xFF577C8E),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * (64 / screenHeight),
            left: screenWidth * (320 / screenWidth),
            child: TextButton(
              child: Text(
                "Skip",
                style: AppTextStyles.Skip,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AfterScreen(),
                  ),
                );
              },
            ),
          ),
          Positioned(
              top: screenHeight * (90 / screenHeight),
              left: screenWidth * (10 / screenWidth),
              child: Image.asset("images/Background.png")),
          Positioned(
            top: screenHeight * (538 / screenHeight),
            left: screenWidth * (170 / screenWidth),
            child: buildDots(currentPage),
          ),
          Positioned(
              top: screenHeight * (574 / screenHeight),
              left: screenWidth * (55 / screenWidth),
              child: Text(
                  "Track your mood and \n   reflect on your day",
                  style:AppTextStyles.headline3)),
          Positioned(
            top: screenHeight * (686 / screenHeight),
            left: screenWidth * (156 / screenWidth),
            child: Container(
                width: screenWidth * (62 / screenWidth),
                height: screenWidth * (62 / screenWidth),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward,
                      size: 30, color: Color(0xFF577C8E)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Screen3(currentPage: 2)),
                    );
                  },
                )),
          ),
        ],
      ),
    ));
  }
}