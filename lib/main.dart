import 'package:flutter/material.dart';
import 'package:graduationproject/screen%20buttonbar/HomeScreen.dart';

import 'BottomBar.dart';
import 'dio_helper.dart';
import 'fontstyle.dart';
import 'frist one/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init(); // init dio before app starts
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        scaffoldBackgroundColor:Color(0xFFF5F5F5)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child:Splashscreen ())),
    );
  }
}
