import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dio_helper.dart';
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
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
