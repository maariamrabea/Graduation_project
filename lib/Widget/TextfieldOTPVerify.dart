import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class TextfieldOTPVerify extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentNode;
  final FocusNode? previousNode;
  final FocusNode? nextNode;

  const TextfieldOTPVerify({
    super.key,
    required this.controller,
    required this.currentNode,
    this.previousNode,
    this.nextNode,
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
        controller: controller,
        focusNode: currentNode,
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextNode != null) {
              FocusScope.of(context).requestFocus(nextNode);
            } else {
              currentNode.unfocus();
            }
          } else {
            if (previousNode != null) {
              FocusScope.of(context).requestFocus(previousNode);
            }
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