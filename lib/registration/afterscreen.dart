import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/registration/login.dart';
import 'package:graduationproject/registration/sign%20up.dart';

import '../fontstyle.dart';

class AfterScreen extends StatelessWidget {
  const AfterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "images/img.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenHeight * 0.73,
            left: screenWidth * (75 / screenWidth),
            child: Text("Let’s join with us!",
                style:AppTextStyles.headline4)),

          Positioned(
            top: screenHeight * 0.8,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Column(
              children: [
                elevatedButton(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>const SignUp(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Color(0xFF577C8E)),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFF577C8E),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
    ),
        ],
      ),
    );
  }
}
