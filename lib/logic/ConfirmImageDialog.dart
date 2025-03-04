import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

class ConfirmImageDialog extends StatelessWidget {
  final XFile image;
  final Function() onRecapture;
  final Function() onConfirm;

  ConfirmImageDialog({
    required this.image,
    required this.onRecapture,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Confirm the photo",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(File(image.path)),
          SizedBox(height: 10),
          Text("Is this image suitable for diagnosis?"),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRecapture();
              },
              child: Text("Recapture", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: Text("OK", style: TextStyle(color: ColorsApp.color1)),
            ),
          ],
        ),
      ],
    );
  }
}