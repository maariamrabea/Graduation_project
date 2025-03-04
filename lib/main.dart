import 'package:flutter/material.dart';
import 'package:graduationproject/onpording/first%20one.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FristScreen(),
    );
  }
}

