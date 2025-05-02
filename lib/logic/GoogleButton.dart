import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../ApiConstants.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: screenWidth * (66 / screenWidth),

        height: screenHeight * (55 / screenHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(onTap: _signInWithGoogle, child: Image.asset("images/Vector.png")),
      ),
    );
  }
}

Future<void> _signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? account = await googleSignIn.signIn();

  if (account != null) {
    final auth = await account.authentication;
    final idToken = auth.idToken;

    // إرسال الـ idToken إلى الباك
    final response = await Dio().post(
      ApiConstants.google,
      data: {'access_token': idToken},
    );

    if (response.statusCode == 200) {
      // تسجيل الدخول ناجح
      print("Login success: ${response.data}");
    } else {
      print("Login failed");
    }
  }
}
