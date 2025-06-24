import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/ApiConstants.dart';
import 'package:http/http.dart' as http;

import '../Widget/Button_resetpassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import '../Widget/arrow_back.dart';
import '../dio_helper.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  const NewPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final url = ApiConstants.dio + ApiConstants.new_password;
    final body = {
      'email': widget.email,
      'password': _passwordController.text,
      'confirm_password': _confirmController.text,
    };

    try {
      final response = await DioHelper.postWithoutAuthRequest(url, data: body);

      final data = response.data;
      debugPrint('⏳ Status: ${response.statusCode}');
      debugPrint('🌐 Resp: $data');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully.')),
        );
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } else {
        String errorMsg = '';
        if (data is Map<String, dynamic>) {
          data.forEach((k, v) {
            if (v is List)
              errorMsg += '$k: ${v.join(", ")}\n';
            else
              errorMsg += '$k: $v\n';
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMsg.trim().isNotEmpty
                  ? errorMsg
                  : (data['detail'] ?? 'Failed to reset password'),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Network error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
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
                const SizedBox(height: 10),
                const Text(
                  'Create New Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your new password must differ from previously used passwords.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                const Text(
                  'New Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                      ),
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter new password';
                    if (v.length < 6) return 'At least 6 characters';
                    if (!RegExp(r'[A-Z]').hasMatch(v))
                      return 'Include uppercase';
                    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include digit';
                    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v))
                      return 'Include special';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                      ),
                      onPressed:
                          () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirm password';
                    if (v != _passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Button_resetpassword(
                  formKey: _formKey,
                  onPressed: _resetPassword,
                ),SizedBox(height: 20,),
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