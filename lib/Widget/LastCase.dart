import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../result/scan_result.dart';

class LastCase extends StatefulWidget {
  @override
  _LastCaseState createState() => _LastCaseState();
}

class _LastCaseState extends State<LastCase> {
  bool isScanCompleted = false;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadLastScan();
  }

  Future<void> _loadLastScan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isScanCompleted = prefs.getBool('is_scan_completed') ?? false;
      imagePath = prefs.getString('last_image_path');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color:
                isScanCompleted && imagePath != null
                    ? Colors.transparent
                    : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow:
                isScanCompleted && imagePath != null
                    ? [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child:
              isScanCompleted && imagePath != null
                  ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ScanResult(
                                imageFile: XFile(
                                  imagePath!,
                                ), // تمرير مسار الصورة
                              ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  )
                  : Center(
                    child: Image.asset(
                      'images/14896150.png',
                      fit: BoxFit.contain,
                    ),
                  ),
        ),
      ),
    );
  }
}
