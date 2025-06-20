import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/BottomBar.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/registration/sign%20up.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import '../logic/buildTextField.dart';

import 'forgetpass.dart';

// افترضت إن الاسم SignUp موجود كـsign_up_screen.dart

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({super.key});

  Future<void> login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // التحقق من أن الحقول ليست فارغة
    if (email.isEmpty || password.isEmpty) {
      showErrorDialog(context, 'Please enter your email and password.');
      return;
    }

    try {
      // إرسال طلب تسجيل الدخول باستخدام DioHelper
      print('Initiating login request to: ${ApiConstants.dio}${ApiConstants.login} with data: {"email": "$email", "password": "$password"}');
      Response response = await DioHelper.postWithoutAuthRequest(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      // التحقق من نجاح الطلب
      if (response.statusCode == 200) {
        final data = response.data;
        String accessToken = data['access'];
        String refreshToken = data['refresh'];

        // تخزين التوكنات في SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        // تحديث رأس Authorization في Dio
        DioHelper.dio.options.headers['Authorization'] = 'Bearer $accessToken';

        print('Login successful: $data');

        // الانتقال إلى الصفحة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
        );
      } else {
        showErrorDialog(context, 'Login failed. Status code: ${response.statusCode}, Response: ${response.data}');
      }
    } catch (e) {
      // معالجة الأخطاء
      String errorMessage = 'Login failed.';
      if (e is DioException) {
        print('DioException caught: Type: ${e.type}, StatusCode: ${e.response?.statusCode}, Response: ${e.response?.data}, Message: ${e.message}');
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timed out. Please check your internet connection.';
        } else if (e.response == null) {
          errorMessage = 'No response from server. Please try again later. Error: ${e.message}';
        } else if (e.response?.statusCode == 400 && e.response?.data is Map) {
          errorMessage = e.response!.data['error'] ?? 'Invalid credentials. Please try again.';
        } else if (e.response?.statusCode == 404) {
          errorMessage = 'Page not found. Please check the API endpoint. Error: ${e.message}';
        } else {
          errorMessage = 'Server error: ${e.response?.data ?? e.message ?? 'Unknown error'}';
        }
      } else {
        print('Unexpected error: $e');
        errorMessage = 'Unexpected error: ${e.toString()}';
      }
      showErrorDialog(context, errorMessage);
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
              'Login to your account',
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
                    hint: 'Email',
                    Controller: emailController,
                    ispassword: false,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    hint: 'Password',
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
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
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

                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don’t have an account? ', style: AppTextStyles.f14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Text(
                          'Sign up',
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
