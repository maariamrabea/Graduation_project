import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/smallContainer.dart';
import 'package:graduationproject/fontstyle.dart';

class ContainerScanScreen extends StatelessWidget {
  const ContainerScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorsApp.color1,
      ),
      height: screenHeight * (150 / screenHeight),
      width: screenWidth * (365 / screenWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Skin Scan",
                style: AppTextStyles.f24.copyWith(color: Colors.white),
              ),
              Text(
                "Check your skin health\n with us.",
                style: AppTextStyles.f14.copyWith(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              SmallContainer(),
              SizedBox(height: 5),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("images/Blob 1.png", width: 130, height: 130),
              Image.asset("images/Group.png", width: 130, height: 130),
            ],
          ),
        ],
      ),
    );
  }
}
