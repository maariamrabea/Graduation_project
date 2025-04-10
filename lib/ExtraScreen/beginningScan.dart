import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/screen%20buttonbar/HomeScreen.dart';

import '../Widget/ElevatedButton.dart';
import '../Widget/arrow_back.dart';
import '../BottomBar.dart';
import '../screen buttonbar/Scan screen.dart';

class BeginningScan extends StatelessWidget {
  const BeginningScan({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomBar()),
            );
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Scan", style: AppTextStyles.f24),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * (55 / screenHeight),
            left: screenWidth * (60 / screenWidth),
            child: DottedBorder(
              color: Color(0xFF577C8E),
              strokeWidth: 2,
              dashPattern: [8, 4],
              borderType: BorderType.RRect,
              radius: Radius.circular(8),
              child: Container(
                width: screenWidth * (271 / screenWidth),
                height: screenHeight * (292 / screenHeight),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    SizedBox(height: 30),
                    Image.asset("images/Group 1000003101.png"),
                    SizedBox(height: 25),
                    Column(
                      children: [
                        Text(
                          "Skin Scan",
                          style: AppTextStyles.f18.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Detect your skin disease",
                          style: AppTextStyles.f14,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * (414 / screenHeight),
            left: screenWidth * (60 / screenWidth),
            child: Container(
              width: screenWidth * (271 / screenWidth),
              height: screenHeight * (48 / screenHeight),
              child: Elevated_Button(
                text: "Scan Now",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SkinScanScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
