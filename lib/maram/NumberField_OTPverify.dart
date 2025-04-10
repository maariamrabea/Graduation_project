import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class textfieldOTPverify extends StatelessWidget {
  const textfieldOTPverify({
    super.key,
    required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: TextField(
        onChanged: (value) {
          if (value.length == 1 &&
              FocusScope.of(context).focusedChild != null) {
            FocusScope.of(context).nextFocus();
          }
        },

        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,

        inputFormatters: [LengthLimitingTextInputFormatter(1)],

        decoration: InputDecoration(
          fillColor: Colors.white60,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 7,
            maxHeight: MediaQuery.of(context).size.height / 7,
          ),
          filled: true,
        ),
      ),
    );
  }
}
