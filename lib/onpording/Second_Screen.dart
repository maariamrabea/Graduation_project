import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/logic/buildDots.dart';
import 'package:graduationproject/onpording/Third_Screen.dart';
import 'package:graduationproject/registration/afterscreen.dart';

class Second_Screen extends StatelessWidget {
  final int currentPage;

  const Second_Screen({required this.currentPage});

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
              child: Image.asset("images/Background (1).png")),
          Positioned(
            top: screenHeight * (538 / screenHeight),
            left: screenWidth * (170 / screenWidth),
            child: buildDots(currentPage),
          ),
          Positioned(
              top: screenHeight * (585 / screenHeight),
              left: screenWidth * (60 / screenWidth),
              child: Text(
                  "Just take a photo — get\n      results in seconds.",
                  style:AppTextStyles.f20)),

          Positioned(
            top: screenHeight * (686 / screenHeight),
            left: screenWidth * (162 / screenWidth),
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
                          builder: (context) => const Third_Screen(currentPage: 2)),
                    );
                  },
                )),
          ),
        ],
      ),
    ));
  }
}