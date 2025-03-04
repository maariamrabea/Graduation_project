import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/appbar.dart';
import 'package:graduationproject/logic/buildTextField.dart';
import 'package:graduationproject/registration/login.dart';

import '../fontstyle.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF577C8E),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * (103 / screenHeight),
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: screenHeight * (709 / screenHeight),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(hint: "Full Name"),
                  const SizedBox(height: 12),
                  buildTextField(hint: "Phone Number"),
                  const SizedBox(height: 12),
                  buildTextField(hint: "Password", isPassword: true),
                  const SizedBox(height: 8),
                  buildTextField(hint: "Confirm Password", isPassword: true),
                  const SizedBox(height: 50),
                  elevatedButton(
                    text: 'Sign Up',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomBar()),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style:AppTextStyles.headline2),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFF577C8E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
