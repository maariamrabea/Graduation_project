import 'package:flutter/material.dart';

class Button_forgotpasspage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final Future<void> Function(String) onSend;

  const Button_forgotpasspage({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          final email = emailController.text.trim();
          onSend(email); // ← استدعاء دالة الإرسال اللي جاية من FirstScreen
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff577C8E),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        textStyle: const TextStyle(fontSize: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: const Text(
        'Send Code',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
          fontWeight: FontWeight.normal,
          fontSize: 15.0,
        ),
      ),
    );
  }
}