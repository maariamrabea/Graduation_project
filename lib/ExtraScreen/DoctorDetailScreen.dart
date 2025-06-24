import 'package:flutter/material.dart';
import 'package:graduationproject/Widget/ElevatedButton.dart';
import 'package:graduationproject/fontstyle.dart';

import '../Widget/arrow_back.dart';
import 'Appointment.dart';

// class DoctorDetailScreen extends StatelessWidget {
//   final String doctorName;
//   final String doctorImage;
//   final String contact;
//   final String workingTime;
//
//   const DoctorDetailScreen({
//     super.key,
//     required this.doctorName,
//     required this.doctorImage,
//     required this.contact,
//     required this.workingTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = const Color(0xFF557C91);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         centerTitle: true,
//         leading: CustomIconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Colors.black,
//         ),
//         title: const Text(
//           'Doctor Details',
//           style: TextStyle(fontWeight: FontWeight.normal),
//         ),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           CircleAvatar(
//             radius: 60,
//             backgroundImage:
//                 doctorImage.isNotEmpty
//                     ? NetworkImage(doctorImage)
//                     : const AssetImage('assets/images/default_doctor.png')
//                         as ImageProvider,
//             onBackgroundImageError: (_, __) {
//               print('Image load error for $doctorImage');
//             },
//           ),
//           //const SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5),
//                       child: Text(
//                         doctorName,
//                         style: AppTextStyles.f24.copyWith(fontSize: 18),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5),
//                       child: Text(
//                         "Skin Specialist",
//                         style: AppTextStyles.f14.copyWith(
//                           fontSize: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child:
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "About Doctor",
//                       style: AppTextStyles.f24.copyWith(fontSize: 18),
//                       textAlign: TextAlign.start,
//                     ),
//                     Text(
//                       " $doctorName is a highly experienced skin specialist with over 10 years of experience in treating various dermatological conditions.",
//                       textAlign: TextAlign.start,
//                       style: AppTextStyles.f14.copyWith(color: Colors.black),
//                     ),
//                     const SizedBox(height: 30),
//                     Text(
//                       "contact",
//                       style: AppTextStyles.f24.copyWith(fontSize: 18),
//                       textAlign: TextAlign.start,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       contact,
//                       style: AppTextStyles.Skip.copyWith(color: Colors.grey),
//                       textAlign: TextAlign.start,
//                     ),
//                     const SizedBox(height: 30),
//                     Text(
//                       "Working Time",
//                       style: AppTextStyles.f24.copyWith(fontSize: 18),
//                       textAlign: TextAlign.start,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       workingTime,
//                       style: AppTextStyles.Skip.copyWith(color: Colors.grey),
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10,),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(height: 50,
//               width: double.infinity,
//               child: Elevated_Button(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => AppointmentScreen(
//                             doctorName: doctorName,
//                             doctorImage: doctorImage,
//                           ),
//                     ),
//                   );
//                 },
//                 text: 'Book Appointment',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DoctorDetailScreen extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  final String contact;
  final String workingTime;
  final int doctorId; // تغيير doctorId ليكون int

  const DoctorDetailScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.contact,
    required this.workingTime,
    required this.doctorId, // مطلوب من DoctorScreen
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF557C91);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: const Text(
          'Doctor Details',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage:
            doctorImage.isNotEmpty
                ? NetworkImage(doctorImage)
                : const AssetImage('assets/images/default_doctor.png')
            as ImageProvider,
            onBackgroundImageError: (_, __) {
              print('Image load error for $doctorImage');
            },
          ),
          //const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        doctorName,
                        style: AppTextStyles.f24.copyWith(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Skin Specialist",
                        style: AppTextStyles.f14.copyWith(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Doctor",
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      " $doctorName is a highly experienced skin specialist with over 10 years of experience in treating various dermatological conditions.",
                      textAlign: TextAlign.start,
                      style: AppTextStyles.f14.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "contact",
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      contact,
                      style: AppTextStyles.f14.copyWith(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Working Time",
                      style: AppTextStyles.f24.copyWith(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      workingTime,
                      style: AppTextStyles.f14.copyWith(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentScreen(
                        doctorName: doctorName,
                        doctorImage: doctorImage,
                        doctorId: doctorId, // doctorId بيكون int
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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