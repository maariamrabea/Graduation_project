import 'dart:convert';

import 'package:flutter/material.dart';
// class Forgetpass extends StatefulWidget {
//   const Forgetpass({super.key});
//
//   @override
//   State<Forgetpass> createState() => _ForgetpassState();
// }
//
// class _ForgetpassState extends State<Forgetpass> {
//   final TextEditingController _emailController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0.0,
//           leading: IconButton(
//             icon: const Icon(Icons.navigate_before),
//             iconSize: 35.0,
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   const SizedBox(height: 3.0),
//                    Text(
//                     "Forgot Password?",
//                     textAlign: TextAlign.start,
//                     style: AppTextStyles.f24
//                   ),
//                   const SizedBox(height: 20.0),
//                    Text(
//                     "Don't worry! It occurs. Please enter the email address linked with your account.",
//                     textAlign: TextAlign.left,
//                     style: AppTextStyles.f14
//                   ),
//                   const SizedBox(height: 40.0),
//                   Text(
//                     "Email",
//                     style: AppTextStyles.f16.copyWith(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextField_forgotpasswordpage(
//                     emailController: _emailController,
//                   ),
//                   const SizedBox(height: 50.0),
//                   Elevated_Button(
//                     text: 'Send Code',
//                     onPressed: () {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const Otdverify(),
//                             ),
//                           );
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

import 'package:http/http.dart' as http;

import '../maram/Textfield_forgotpasspage.dart';

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<Forgetpass> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetEmail(String email) async {
    print("🚀 Send button clicked with email: $email");
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
      'https://3baf-197-35-170-25.ngrok-free.app/api/users/password/otp/request/',
    ); //  غيره حسب سيرفرك

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // تم الإرسال بنجاح
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Success"),
                content: Text(
                  responseData['message'] ?? 'Check your email for reset link.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        // خطأ من السيرفر
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Error"),
                content: Text(
                  responseData['message'] ?? 'Something went wrong.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      // خطأ في الاتصال أو غيره
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Error"),
              content: Text('Failed to connect to server.\n$e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      _emailController.clear();
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      sendResetEmail(email);
    }
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
                  const Text(
                    "Forgot Password?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Don't worry! It occurs. Please enter the email address linked with your account.",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField_forgotpasswordpage(
                    emailController: _emailController,
                  ),
                  const SizedBox(height: 50.0),
                  Button_forgotpasspage(
                    formKey: _formKey,
                    emailController: _emailController,
                    onSend: sendResetEmail,
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
