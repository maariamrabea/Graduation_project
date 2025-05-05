import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

import '../Widget/arrow_back.dart';
import 'Schedule.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  final String contact;
  final String workingTime;

  const DoctorDetailScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.contact,
    required this.workingTime,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF557C91);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text('Doctor Details', style: AppTextStyles.f24),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(radius: 60, backgroundImage: AssetImage(doctorImage)),
          //const SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // الحواف الدائرية
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                    ),
                    Text(
                      "Skin Specialist",
                      style: AppTextStyles.f14.copyWith(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // الحواف الدائرية
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "About Doctor",
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),

                    Text(
                      "Dr. $doctorName is a highly experienced skin specialist with over 10 years of experience in treating various dermatological conditions.",
                      textAlign: TextAlign.start,
                      style: AppTextStyles.f14.copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "contact",
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10),
                    Text(
                      contact,
                      style: AppTextStyles.Skip.copyWith(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Working Time",
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10),
                    Text(
                      workingTime,
                      style: AppTextStyles.Skip.copyWith(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AppointmentScreen(
                            doctorName: doctorName,
                            doctorImage: doctorImage,
                          ),
                    ),
                  );
                },
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
