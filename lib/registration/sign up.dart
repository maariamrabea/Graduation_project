import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/ApiConstants.dart';

import '../Widget/ElevatedButton.dart';
import '../dio_helper.dart';
import '../fontstyle.dart';
import '../logic/buildTextField.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateButtonState);
    phoneController.addListener(updateButtonState);
    emailController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
    confirmPasswordController.addListener(updateButtonState);
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r"^\+?\d{10,15}$").hasMatch(phone);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          passwordController.text == confirmPasswordController.text;
    });
  }

  Future<void> register(BuildContext context) async {
    if (!isButtonEnabled) {
      showErrorDialog(context, "Please fill all the fields!");
      return;
    }

    String apiUrl = ApiConstants.signup;

    try {
      Response response = await DioHelper.postWithoutAuthRequest(
        apiUrl,
        data: {
          "full_name": nameController.text.trim(),
          "phone_number": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text,
          "confirm_password": confirmPasswordController.text,
        },
      );

      if (response.statusCode == 201) {
        // نجاح التسجيل
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Success"),
                content: const Text(
                  "Account created successfully! Please log in.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: const Text("Go to Login"),
                  ),
                ],
              ),
        );
      } else {
        showErrorDialog(context, "Registration failed. Please try again.");
      }
    } catch (e) {
      if (e is DioError) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode == 400 && responseData is Map) {
          String errorMessage = responseData.values
              .map(
                (value) => value is List ? value.join("\n") : value.toString(),
              )
              .join("\n");
          showErrorDialog(context, errorMessage);
        } else {
          showErrorDialog(context, "Server error: ${e.message}");
        }
      } else {
        showErrorDialog(context, "Unexpected error: ${e.toString()}");
      }
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF577C8E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Container(
              width: double.infinity,
              height: screenHeight * (723 / screenHeight),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text("Sign Up", style: AppTextStyles.f24),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    hint: "Full Name",
                    Controller: nameController,
                    ispassword: false,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    hint: "Phone Number",
                    Controller: phoneController,
                    ispassword: false,
                  ),
                  const SizedBox(height: 12),
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
                  buildTextField(
                    hint: "Confirm Password",
                    Controller: confirmPasswordController,
                    ispassword: true,
                  ),
                  const SizedBox(height: 50),
                  Elevated_Button(
                    text: 'Sign Up',
                    onPressed:
                        isButtonEnabled
                            ? () => register(context)
                            : () {
                              showErrorDialog(
                                context,
                                "Please fill all the fields!",
                              );
                            },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: AppTextStyles.f14,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
