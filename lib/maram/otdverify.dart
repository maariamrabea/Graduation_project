import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';

import '../Widget/arrow_back.dart';
import '../fontstyle.dart';
import 'NumberField_OTPverify.dart';
import 'controllers.dart';
import 'newpassword.dart';

class Otdverify extends StatefulWidget {
  const Otdverify({super.key});

  @override
  State<Otdverify> createState() => _OtdverifyState();
}

class _OtdverifyState extends State<Otdverify> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: CustomIconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 3.0),
              Text(
                "OTP Verification",
                textAlign: TextAlign.start,
                style: AppTextStyles.f24.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20.0),
               Text(
                "Enter the verfication code we just sent to your email address.",
                textAlign: TextAlign.left,
                style: AppTextStyles.f14,
              ),
              const SizedBox(height: 50.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textfieldOTPverify(controller: c1),

                  textfieldOTPverify(controller: c2),

                  textfieldOTPverify(controller: c3),

                  textfieldOTPverify(controller: c4),
                ],
              ),

              const SizedBox(height: 40.0),
              Elevated_Button(
                text: "Verify",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Newpassword(),
                    ),
                  );
                },
              ),
              //  Button_verify(),
            ],
          ),
        ),
      ),
    );
  }
}
