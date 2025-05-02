import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homewidget/Middle_Bart.dart';
import '../homewidget/endpart.dart';
import '../homewidget/upper_part.dart';

// class HomeScreen extends StatelessWidget {
//   final Map<String, dynamic>? doctor; // بيانات الدكتور (ممكن تكون null)
//
//   HomeScreen({this.doctor});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(children: [UpperPart(), MiddleBart(), EndBart()]),
//       ),
//     );
//   }
// }
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasAppointment = false;

  @override
  void initState() {
    super.initState();
    checkForAppointment();
  }

  Future<void> checkForAppointment() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorName = prefs.getString('doctor_name');
    if (doctorName != null && doctorName.isNotEmpty) {
      setState(() {
        hasAppointment = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(child:  Column(
        children: [
          UpperPart(),

          if (hasAppointment) MiddleBart(),
          EndBart(), // يظهر فقط عند وجود حجز
        ],
      ),),
    );
  }
}
