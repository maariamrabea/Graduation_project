import 'package:flutter/material.dart';
import 'package:graduationproject/logic/buildDots.dart';
import 'package:graduationproject/registration/afterscreen.dart';

import '../fontstyle.dart';

class Third_Screen extends StatelessWidget {
  const Third_Screen({super.key, required int currentPage});

  @override
  Widget build(BuildContext context) {
    int currentPage = 2;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return (Scaffold(
      backgroundColor: const Color(0xFF577C8E),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * (90 / screenHeight),
            left: screenWidth * (10 / screenWidth),
            child: Image.asset("images/Background (2).png"),
          ),
          Positioned(
            top: screenHeight * (538 / screenHeight),
            left: screenWidth * (170 / screenWidth),
            child: buildDots(currentPage),
          ),
          Positioned(
              top: screenHeight * (585 / screenHeight),
              left: screenWidth * (50 / screenWidth),
              child: Text(
                  "Your data stays safe and\n                confidential.",
                  style:AppTextStyles.f20.copyWith(color: Colors.white))),
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
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: Color(0xFF577C8E),
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
          ),
        ],
      ),
    ));
  }
}
