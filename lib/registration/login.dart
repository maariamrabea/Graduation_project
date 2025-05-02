import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/BottomBar.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/logic/buildTextField.dart';
import 'package:graduationproject/registration/sign%20up.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import '../logic/GoogleButton.dart';
import '../logic/facebookButton.dart';
import 'forgetpass.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({super.key});

  Future<void> login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog(context, "Please enter your email and password.");
      return;
    }

    String apiUrl = "https://3baf-197-35-170-25.ngrok-free.app/api/users/login/";
        //ApiConstants.login;

    try {
      Response response = await DioHelper.dio.post(
        apiUrl,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        String accessToken = response.data["access"];
        String refreshToken = response.data["refresh"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", accessToken);
        await prefs.setString("refresh_token", refreshToken);

        DioHelper.dio.options.headers["Authorization"] = "Bearer $accessToken";

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
        );
      } else {
        showErrorDialog(context, "Login failed. Please try again.");
      }
    } catch (e) {
      if (e is DioError) {
        String errorMessage = "Login failed.";
        if (e.response != null && e.response?.data != null) {
          errorMessage = e.response?.data.toString() ?? errorMessage;
        }
        showErrorDialog(context, errorMessage);
      } else {
        showErrorDialog(context, "An unexpected error occurred.");
      }
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF577C8E),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.148,
            left: screenWidth * 0.05,
            child: Text(
              "Login to your account",
              style: AppTextStyles.f24.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
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
                  buildTextField(
                    hint: "Email",
                    Controller: emailController,
                    ispassword: false,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    hint: "Password",
                    Controller: passwordController,
                    ispassword: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Forgetpass()),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: AppTextStyles.f14.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Elevated_Button(
                    onPressed: () => login(context),
                    text: 'Login',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text("or login with", style: AppTextStyles.f14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoogleButton(),
                      const SizedBox(width: 30),
                      facebookButton(),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account? ", style: AppTextStyles.f14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
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
