import 'package:flutter/material.dart';

import '../Widget/ElevatedButton.dart';
import '../fontstyle.dart';
import '../maram/Textfield_forgotpasspage.dart';
import '../maram/otdverify.dart';

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            iconSize: 35.0,
            onPressed: () => Navigator.pop(context),
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
                  const SizedBox(height: 3.0),
                   Text(
                    "Forgot Password?",
                    textAlign: TextAlign.start,
                    style: AppTextStyles.f24
                  ),
                  const SizedBox(height: 20.0),
                   Text(
                    "Don't worry! It occurs. Please enter the email address linked with your account.",
                    textAlign: TextAlign.left,
                    style: AppTextStyles.f14
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    "Email",
                    style: AppTextStyles.f16.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField_forgotpasswordpage(
                    emailController: _emailController,
                  ),
                  const SizedBox(height: 50.0),
                  Elevated_Button(
                    text: 'Send Code',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Otdverify(),
                            ),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
