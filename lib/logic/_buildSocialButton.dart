
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildSocialButton(String assetPath,BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child:Container(
        width: screenWidth*(66/screenWidth),

        height:screenHeight*( 55/screenHeight),
        //padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        decoration:  BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),


        child:Image.asset(assetPath),) // Placeholder icon
  );
}