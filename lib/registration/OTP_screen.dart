
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widget/Button_verifyotp.dart widget.dart';
import '../Widget/TextfieldOTPVerify.dart';
import '../Widget/arrow_back.dart';
import '../fontstyle.dart';

class Otpverify extends StatefulWidget {
  final String email;

  const Otpverify({super.key, required this.email});

  @override
  State<Otpverify> createState() => _OtpverifyState();
}

class _OtpverifyState extends State<Otpverify> {
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();
  final TextEditingController c3 = TextEditingController();
  final TextEditingController c4 = TextEditingController();

  final FocusNode f1 = FocusNode();
  final FocusNode f2 = FocusNode();
  final FocusNode f3 = FocusNode();
  final FocusNode f4 = FocusNode();

  @override
  void dispose() {
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(
              context,
              //MaterialPageRoute(builder: (context) => BottomBar()),
            );
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 3.0),
            const Text(
              "OTP Verification",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Enter the verification code we just sent to your email address.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextfieldOTPVerify(
                  controller: c1,
                  currentNode: f1,
                  nextNode: f2,
                  previousNode: null,
                ),
                TextfieldOTPVerify(
                  controller: c2,
                  currentNode: f2,
                  nextNode: f3,
                  previousNode: f1,
                ),
                TextfieldOTPVerify(
                  controller: c3,
                  currentNode: f3,
                  nextNode: f4,
                  previousNode: f2,
                ),
                TextfieldOTPVerify(
                  controller: c4,
                  currentNode: f4,
                  nextNode: null,
                  previousNode: f3,
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            ButtonVerify(otpControllers: [c1, c2, c3, c4], email: widget.email),
          ],
        ),
      ),
    );
  }
}