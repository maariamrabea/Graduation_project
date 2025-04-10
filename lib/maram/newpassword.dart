import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/fontstyle.dart';

import '../BottomBar.dart';
import '../Widget/arrow_back.dart';
class Newpassword extends StatefulWidget {
  const Newpassword({super.key});

  @override
  State<Newpassword> createState() => _NewpasswordState();
}

class _NewpasswordState extends State<Newpassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHidden = false;
  bool isHidden2 = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () =>
          FocusScope.of(
            context,
          ).unfocus(), // إخفاء الكيبورد عند الضغط خارج الحقول
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: CustomIconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 1),
                  Text(
                    "Create New Password",
                    textAlign: TextAlign.start,
                    style: AppTextStyles.f24,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Your new password must be unique from previously used passwords.",
                    textAlign: TextAlign.left,
                    style: AppTextStyles.f14,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    "New Password",
                    style: AppTextStyles.f16.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !isHidden,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isHidden
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: "Enter new password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your new password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      if (value.length > 15) {
                        return "Password must not exceed 15 characters";
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return "Password must contain at least one uppercase letter";
                      }

                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return "Password must contain at least one digit";
                      }
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return "Password must contain at least one special character";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    "Confirm Password",
                    style: AppTextStyles.f16.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !isHidden2,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isHidden2
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            isHidden2 = !isHidden2;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: "Confirm new password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40.0),
                  Elevated_Button(text: 'Reset Password',  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BottomBar()),
                      );
                    }
                  },),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
