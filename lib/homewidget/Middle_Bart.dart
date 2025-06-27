import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ExtraScreen/RemindersScreen.dart';

class MiddleBart extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  final String appointmentDate;

  const MiddleBart({
    Key? key,
    required this.doctorName,
    required this.doctorImage,
    required this.appointmentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * (227 / screenHeight),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming appointments",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RemindersScreen()),
                  );
                },
                child: Text("See all",   style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF567A88),
                  fontWeight: FontWeight.w600,
                )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 131,
            width: 355,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      doctorImage.isNotEmpty
                          ? Image.network(
                            doctorImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Image load error: $error');
                              return const Icon(Icons.person, size: 50);
                            },
                          )
                          : const Icon(Icons.person, size: 50),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Dermatological examination',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: 311,
                    decoration: BoxDecoration(
                      color: Color(0xFFE3EDF2), // الخلفية
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:Center(child:  Text(
                      appointmentDate,
                      style: TextStyle(fontSize: 14),
                    ),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
