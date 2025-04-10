import 'package:flutter/material.dart';

class TextField_forgotpasswordpage extends StatelessWidget {
  const TextField_forgotpasswordpage({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: "Enter your email",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        if (!value.contains("@gmail.com")) {
          return "Please enter a valid email";
        }

        return null;
      },
    );
  }
}
