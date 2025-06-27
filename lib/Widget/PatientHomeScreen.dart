// import 'package:flutter/material.dart';
//
//
//
// class PatientHomeScreen extends StatelessWidget {
//   final String doctorName;
//   final String doctorImage;
//   final String appointmentDate;
//
//   const PatientHomeScreen({
//     Key? key,
//     required this.doctorName,
//     required this.doctorImage,
//     required this.appointmentDate,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 131,
//               width: 355,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         doctorImage.isNotEmpty
//                             ? Image.network(
//                           doctorImage,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             print('Image load error: $error');
//                             return const Icon(Icons.person, size: 50);
//                           },
//                         )
//                             : const Icon(Icons.person, size: 50),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               doctorName,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Text(
//                               'Dermatological examination', // يمكن تعديلها لو فيه حقل تخصص
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     Text(
//                       appointmentDate,
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }