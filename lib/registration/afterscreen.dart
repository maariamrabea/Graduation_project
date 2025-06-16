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
            child: Image.asset("images/c74cca2d-2e12-4a3b-a6c3-334cefdfe267.jpg", fit: BoxFit.cover),
          ),
          Positioned(
            top: screenHeight * 0.73,
            left: screenWidth * (80 / screenWidth),
            child: Text(
              "Let’s join with us!",
              style: AppTextStyles.f24.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.8,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Column(
              children: [
                Elevated_Button(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SignUp()),
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
                  child: Text(
                    "Login",
                    style: AppTextStyles.f18.copyWith(
                      fontWeight: FontWeight.w500,
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
