import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/ApiConstants.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';

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
  final TextEditingController confirmPasswordController = TextEditingController();

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
              passwordController.text == confirmPasswordController.text &&
              isValidEmail(emailController.text) &&
              isValidPhone(phoneController.text);
    });
  }

  Future<void> register(BuildContext context) async {
    if (!isButtonEnabled) {
      showErrorDialog(context, "Please fill all fields correctly!");
      return;
    }

    String apiUrl = ApiConstants.signup;

    try {
      print('Initiating signup request to: ${ApiConstants.dio}$apiUrl with data: ${{
        "email": emailController.text.trim(),
        "full_name": nameController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "password": passwordController.text,
        "confirm_password": confirmPasswordController.text,
      }}');
      Response response = await DioHelper.postWithoutAuthRequest(
        apiUrl,
        data: {
          "email": emailController.text.trim(),
          "full_name": nameController.text.trim(),
          "phone_number": phoneController.text.trim(),
          "password": passwordController.text,
          "confirm_password": confirmPasswordController.text,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(data['message'] ?? "Account created successfully! Please log in."),
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
        showErrorDialog(context, "Registration failed. Status code: ${response.statusCode}, Response: ${response.data['error'] ?? response.data}");
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException caught: Type: ${e.type}, StatusCode: ${e.response?.statusCode}, Response: ${e.response?.data}, Message: ${e.message}');
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          showErrorDialog(context, "Connection timed out. Please check your internet connection.");
        } else if (e.response == null) {
          showErrorDialog(context, "No response from server. Please try again later. Error: ${e.message}");
        } else if (e.response?.statusCode == 400) {
          String errorMessage = e.response!.data['error'] ?? e.response!.data['email'] ?? e.response!.data['phone_number'] ?? 'Invalid data. Please check your input.';
          showErrorDialog(context, errorMessage);
        } else if (e.response?.statusCode == 404) {
          showErrorDialog(context, "Page not found. Please check the API endpoint. Error: ${e.message}");
        } else {
          showErrorDialog(context, "Server error: ${e.response?.data ?? e.message ?? 'Unknown error'}");
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
                    onPressed: isButtonEnabled ? () => register(context) : null,

                    text:'Sign Up',
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