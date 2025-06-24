import 'package:flutter/material.dart';

import '../fontstyle.dart';

class Button_resetpassword extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;

  const Button_resetpassword({
    super.key,
    required this.formKey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: const Color(0xff577C8E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          onPressed(); // استدعاء الدالة اللي جاية من بره
        }
      },
      child: Text(
        "Reset Password",
        style: AppTextStyles.f18.copyWith(color: Colors.white),
      ),
    );
  }
}
