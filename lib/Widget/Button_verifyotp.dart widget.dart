import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import '../fontstyle.dart';
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

    if (otp.length == 4 && otpControllers.every((c) => c.text.isNotEmpty)) {
      try {
        final url = ApiConstants.dio + ApiConstants.otp;
        final response = await DioHelper.postWithoutAuthRequest(
          url,
          data: {"email": email, "otp": otp},
        );

        final data = response.data;
        debugPrint('⌛ ${response.statusCode} ← $data');

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'OTP verified successfully'),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewPasswordScreen(email: email)),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff577C8E),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        "Verify",
        style: AppTextStyles.f18.copyWith(color: Colors.white),
      ),
    );
  }
}
