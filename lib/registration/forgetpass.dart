import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../Widget/Button_forgotpasspage.dart';
import 'OTP_screen.dart';
import '../Widget/arrow_back.dart';
import '../Widget/textfield in forgetpassword page.dart';
import '../dio_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final body = {'email': _emailController.text.trim()};
    final fullUrl = ApiConstants.dio + ApiConstants.forget_password;

    try {
      final response = await DioHelper.postWithoutAuthRequest(
        fullUrl,
        data: body,
      );

      final data = response.data;

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Otpverify(email: _emailController.text.trim()),
          ),
        );
      } else {
        _showMessage(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      _showMessage('Network error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: CustomIconButton(
            onPressed: () {
              Navigator.pop(
                context,

              );
            },
            color: Colors.black,
          ),
          backgroundColor: Colors.white,

        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Don't worry! it occurs, Please Enter the\n email address linked with your account.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextField_forgotpasswordpage(emailController: _emailController),
                const SizedBox(height: 40),
                Button_forgotpasspage(
                  formKey: _formKey,
                  emailController: _emailController,
                  onSend: (email) => _requestOtp(),
                ),
                SizedBox(height: 20,),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}