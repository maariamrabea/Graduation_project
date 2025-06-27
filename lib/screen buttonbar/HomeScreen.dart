import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homewidget/Middle_Bart.dart';
import '../homewidget/endpart.dart';
import '../homewidget/upper_part.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasAppointment = false;
  String doctorName = 'Unknown Doctor';
  String doctorImage = '';
  String appointmentDate = 'No appointment selected';

  @override
  void initState() {
    super.initState();
    checkForAppointment();
  }

  Future<void> checkForAppointment() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDoctorName = prefs.getString('doctorName');
    if (savedDoctorName != null && savedDoctorName.isNotEmpty) {
      setState(() {
        hasAppointment = true;
        doctorName = savedDoctorName;
        doctorImage = prefs.getString('doctorImage') ?? '';
        appointmentDate = prefs.getString('appointmentDate') ?? 'No appointment selected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            UpperPart(),
            if (hasAppointment)
              MiddleBart(
                doctorName: doctorName,
                doctorImage: doctorImage,
                appointmentDate: appointmentDate,
              ),
            EndBart(),
          ],
        ),
      ),
    );
  }
}