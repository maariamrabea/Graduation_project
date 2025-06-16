import 'dart:convert';
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

// class Login extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   Login({super.key});
//
//   Future<void> login(BuildContext context) async {
//     // تنظيف التوكن القديم
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove("access_token");
//     await prefs.remove("refresh_token");
//
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       showErrorDialog(context, "Please enter your email and password.");
//       return;
//     }
//
//     String apiUrl = ApiConstants.login; // "users/login/"
//
//     try {
//       Response response = await DioHelper.postWithoutAuth(
//         apiUrl,
//         {
//           "email": email,
//           "password": password,
//         },
//       );
//
//       print("Login Request URL: ${DioHelper.dio.options.baseUrl}$apiUrl");
//       print("Login Response Status: ${response.statusCode}");
//       print("Login Response Data: ${response.data}");
//
//       if (response.statusCode == 200) {
//         dynamic data = response.data;
//         if (data is String) {
//           try {
//             data = json.decode(data);
//           } catch (e) {
//             showErrorDialog(context, "Server returned invalid JSON.");
//             return;
//           }
//         }
//
//         String accessToken = data["access"];
//         String refreshToken = data["refresh"];
//
//         await prefs.setString("access_token", accessToken);
//         await prefs.setString("refresh_token", refreshToken);
//
//         DioHelper.dio.options.headers["Authorization"] = "Bearer $accessToken";
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => BottomBar()),
//         );
//       } else {
//         showErrorDialog(context, "Login failed. Status: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is DioError) {
//         String errorMessage = "Login failed.";
//         if (e.response != null) {
//           print("Login Error Status: ${e.response?.statusCode}");
//           print("Login Error Data: ${e.response?.data}");
//           errorMessage = "Server error: ${e.response?.statusCode}";
//           if (e.response?.data is String && e.response!.data.contains("<html")) {
//             errorMessage = "Server returned HTML. Check API URL or server status.";
//           }
//         }
//         showErrorDialog(context, errorMessage);
//       } else {
//         showErrorDialog(context, "An unexpected error occurred: $e");
//       }
//     }
//   }
//
//   void showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text("Error"),
//             content: Text(message),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK"),
//               ),
//             ],
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF577C8E),
//       body: Stack(
//         children: [
//           Positioned(
//             top: screenHeight * 0.148,
//             left: screenWidth * 0.05,
//             child: Text(
//               "Login to your account",
//               style: AppTextStyles.f24.copyWith(
//                 color: Colors.white,
//                 fontSize: 22,
//               ),
//             ),
//           ),
//           Positioned(
//             top: screenHeight * 0.232,
//             left: 0,
//             right: 0,
//             child: Container(
//               width: double.infinity,
//               height: screenHeight * (626 / screenHeight),
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 50),
//                   buildTextField(
//                     hint: "Email",
//                     Controller: emailController,
//                     ispassword: false,
//                   ),
//                   const SizedBox(height: 12),
//                   buildTextField(
//                     hint: "Password",
//                     Controller: passwordController,
//                     ispassword: true,
//                   ),
//                   const SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ForgotPasswordScreen(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "Forgot Password?",
//                         style: AppTextStyles.f14.copyWith(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Elevated_Button(
//                     onPressed: () => login(context),
//                     text: 'Login',
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: Text("or login with", style: AppTextStyles.f14),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GoogleButton(),
//                       const SizedBox(width: 30),
//                       facebookButton(),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Don’t have an account? ", style: AppTextStyles.f14),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => SignUp()),
//                           );
//                         },
//                         child: const Text(
//                           "Sign up",
//                           style: TextStyle(
//                             color: Color(0xFF577C8E),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



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
      // إرسال طلب تسجيل الدخول بدون رأس Authorization
      Response response = await DioHelper.postWithoutAuth(
        ApiConstants.login,
        {
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
        showErrorDialog(context, 'Login failed. Please try again.');
      }
    } catch (e) {
      // معالجة الأخطاء
      String errorMessage = 'Login failed.';
      if (e is DioError && e.response != null && e.response?.data != null) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorMessage;
        print('Login error response: $errorData');
      } else {
        print('Login error: $e');
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
                  const SizedBox(height: 20),
                  Center(
                    child: Text('or login with', style: AppTextStyles.f14),
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

  // تعريف مؤقت لـ buildTextField
  // استبدليه بالتعريف الفعلي في تطبيقك إذا كان موجودًا
  Widget buildTextField({
    required String hint,
    required TextEditingController Controller,
    required bool ispassword,
  }) {
    return TextField(
      controller: Controller,
      obscureText: ispassword,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}