import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/time.dart';

class MiddleBart extends StatefulWidget {
  const MiddleBart({super.key});

  @override
  _MiddleBartState createState() => _MiddleBartState();
}

// class _MiddleBartState extends State<MiddleBart> {
//   String? doctorName;
//   String? doctorSpecialty;
//   String? doctorImage;
//
//   @override
//   void initState() {
//     super.initState();
//     loadDoctorData();
//   }
//
//   void loadDoctorData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       doctorName = prefs.getString('doctor_name') ?? "No doctor yet";
//       doctorSpecialty = prefs.getString('doctor_specialty') ?? "";
//       doctorImage = prefs.getString('doctor_image');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Container(
//       height: screenHeight * (227 / screenHeight),
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Upcoming appointments",
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text("See all"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             height: 131,
//             width: 355,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       doctorImage != null
//                           ? Image.asset(doctorImage!, width: 50, height: 50)
//                           : Icon(Icons.person, size: 50),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             doctorName ?? '',
//                             style: AppTextStyles.f16.copyWith(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             doctorSpecialty ?? '',
//                             style: AppTextStyles.f14.copyWith(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 90),
//                       GestureDetector(
//                         onTap: () {},
//                         child: Container(
//                           width: 38,
//                           height: 38,
//                           decoration: BoxDecoration(
//                             color: ColorsApp.color1,
//                             borderRadius: BorderRadius.circular(20),
//                             image: DecorationImage(
//                               image: AssetImage("images/messages-3.png"),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   Time(appointmentDate: DateTime(2025, 2, 2, 9, 0)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class _MiddleBartState extends State<MiddleBart> {
  String? doctorName;
  String? doctorSpecialty;
  String? doctorImage;
  String? appointmentDateString;

  @override
  void initState() {
    super.initState();
    loadDoctorData();
  }

  void loadDoctorData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorName = prefs.getString('doctor_name') ?? "No doctor yet";
      doctorSpecialty = prefs.getString('doctor_specialty') ?? "";
      doctorImage = prefs.getString('doctor_image');
      appointmentDateString = prefs.getString('appointment_date');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    DateTime? appointmentDate =
        appointmentDateString != null
            ? DateTime.tryParse(appointmentDateString!)
            : null;

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
              TextButton(onPressed: () {}, child: const Text("See all")),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      doctorImage != null
                          ? Image.asset(doctorImage!, width: 50, height: 50)
                          : const Icon(Icons.person, size: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName ?? '',
                            style: AppTextStyles.f16.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            doctorSpecialty ?? '',
                            style: AppTextStyles.f14.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 90),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: ColorsApp.color1,
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage("images/messages-3.png"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  appointmentDate != null
                      ? Time(appointmentDate: appointmentDate)
                      : const Text("No appointment selected"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
