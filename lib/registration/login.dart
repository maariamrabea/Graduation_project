import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/Widget/arrow_back.dart';
import 'package:graduationproject/appbar.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/logic/_buildSocialButton.dart';
import 'package:graduationproject/logic/buildTextField.dart';
import 'package:graduationproject/onpording/first%20one.dart';
import 'package:graduationproject/registration/sign%20up.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF577C8E),
      body: Stack(
        children: [
          Positioned(
              top: screenHeight * (45 / screenHeight),
              left: screenWidth * (8 / screenWidth),
              child: CustomIconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FristScreen(),
                      ));
                },
              )),
          Positioned(
            top: screenHeight * 0.148,
            left: screenWidth * (20 / screenWidth),
            child: Text(
              "Login to your account",
              style: AppTextStyles.headline4)


          ),
          Positioned(
            top: screenHeight * 0.232,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: screenHeight * (626 / screenHeight),
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
                  const SizedBox(height: 50),
                  buildTextField(hint: "Email"),
                  const SizedBox(height: 12),
                  buildTextField(hint: "Password", isPassword: true),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: AppTextStyles.headline2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  elevatedButton(
                    onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomBar(),
                        ));},
                    text: 'Login',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "or login with",
                      style: AppTextStyles.headline2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildSocialButton("images/Vector.png", context),
                      const SizedBox(
                        width: 30,
                      ),
                      buildSocialButton("images/facebook.png", context),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account? ",
                        style: AppTextStyles.headline2,
                      ),
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ));
                        },
                        child: const Text(
                          "Sign up",
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
