import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ApiConstants.dart';
import '../registration/newpassowrd.dart';

class ButtonVerify extends StatelessWidget {
  final List<TextEditingController> otpControllers;
  final String email;

  const ButtonVerify({
    super.key,
    required this.otpControllers,
    required this.email,
  });

  Future<void> _verifyOtp(BuildContext context) async {
    String otp = otpControllers.map((c) => c.text).join();

    if (otp.length == 4) {
      try {
        final response = await http.post(
          Uri.parse(ApiConstants.otp),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"email": email, "otp": otp}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      NewPasswordScreen(uid: data['uid'], token: data['token']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['detail'] ?? 'Invalid OTP')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Network error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _verifyOtp(context),
      child: const Text(
        "Verify",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
          fontSize: 16.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff577C8E),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
