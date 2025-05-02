import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen buttonbar/HomeScreen.dart';
class DoctorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(doctor['image']),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Cairo, Egypt",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFEDF3F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    doctor['price'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildDoctorInfo(),
            SizedBox(height: 20),
            _buildAboutDoctor(),
            Spacer(),
            Center(
              child:
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  // تأكد من القيم
                  final doctorName = doctor['name'] ?? 'Unknown Doctor';
                  final doctorSpecialty = doctor['specialty'] ?? 'Unknown Specialty';
                  final doctorImage = doctor['image'] ?? 'images/default.png';

                  // حفظ البيانات
                  await prefs.setString('doctor_name', doctorName);
                  await prefs.setString('doctor_specialty', doctorSpecialty);
                  await prefs.setString('doctor_image', doctorImage);

                  // رسالة التأكيد
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text("Your reservation has been completed successfully"),
                      content: Text("The appointment was successfully booked with the doctor $doctorName."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // يقفل الـ dialog
                            Navigator.pop(context); // يرجع خطوة
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                },



                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsApp.color1,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Book Appointment",
                  style:AppTextStyles.f16
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 30),
        SizedBox(height: 5),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _infoItem(Icons.people, "140 Patient"),
        _infoItem(Icons.star, "${doctor['rating']} Rating"),
        _infoItem(Icons.work, "3Y Exp."),
      ],
    );
  }

  Widget _buildAboutDoctor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Doctor",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Medical specialist who diagnoses and treats skin, hair, and nail conditions. Help manage issues like acne and skin cancer through medical treatment.",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        SizedBox(height: 40),
        Text(
          "Working Time",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Sunday - Monday, 9:00 AM To 11 PM.",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        SizedBox(height: 40),
        Text(
          "Contact",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "+20 111 694 2750",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }
}