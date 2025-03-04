import 'package:flutter/material.dart';

import '../Widget/ContainerScanScreen.dart';
import '../Widget/HomeAppbar.dart';

class UpperPart extends StatelessWidget {
  const UpperPart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  Container(
        height: screenHeight * (345 / screenHeight),
        width: screenWidth * (386 / screenWidth),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child:Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
          children: [
            Positioned(
              top: screenHeight * (70 / screenHeight),
              child: HomeAppBar(),
            ),
            Positioned(
              top: screenHeight * (145 / screenHeight),
              child: ContainerScanScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
