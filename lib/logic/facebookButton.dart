

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:graduationproject/ApiConstants.dart';

class facebookButton extends StatelessWidget {
  const facebookButton({super.key});
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
        child: InkWell(onTap:_signInWithFacebook , child: Image.asset("images/facebook.png")),
      ),
    );
  }
}
Future<void> _signInWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance.login();

  if (result.status == LoginStatus.success && result.accessToken != null) {
    final String accessToken = result.accessToken!.tokenString;

    try {
      final response = await Dio().post(
        ApiConstants.google,
        data: {'access_token': accessToken},
      );

      if (response.statusCode == 200) {
        print("Facebook login success: ${response.data}");
      } else {
        print("Facebook login failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during Facebook login request: $e");
    }

  } else {
    print("Facebook login error: ${result.status}");
  }
}