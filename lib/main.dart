import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'frist one/SplashScreen.dart';

void main() {
  if (kReleaseMode) {
    print("🚀 Running in RELEASE mode");
  } else {
    print("🐞 Running in DEBUG mode");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
