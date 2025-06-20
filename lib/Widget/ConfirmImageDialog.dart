import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';

class ConfirmImageDialog extends StatelessWidget {
  final XFile image;
  final VoidCallback onRecapture;
  final VoidCallback onConfirm;

  const ConfirmImageDialog({
    required this.image,
    required this.onRecapture,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(File(image.path), height: 200, fit: BoxFit.cover),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Elevated_Button(
                onPressed: onRecapture,
               text:('Recapture'),
              ),
              Elevated_Button(
                onPressed: onConfirm,
              text:('Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}