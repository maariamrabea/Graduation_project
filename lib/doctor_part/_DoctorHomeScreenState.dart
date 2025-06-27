import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fontstyle.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ستحتاجينها لتنسيق التاريخ والوقت
//
// class Time extends StatelessWidget {
//   final DateTime appointmentDate;
//   final String appointmentTime; // أضفت الوقت لأنه مهم في المواعيد
//
//   const Time({
//     super.key,
//     required this.appointmentDate,
//     required this.appointmentTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // استخدمي DateFormat لتنسيق التاريخ والوقت كما تريدين
//     final String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(appointmentDate); // مثال: Monday, Jun 22, 2025
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
//             const SizedBox(width: 8),
//             Text(
//               formattedDate,
//               style: AppTextStyles.f14.copyWith(color: Colors.grey),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             const Icon(Icons.access_time, size: 16, color: Colors.grey),
//             const SizedBox(width: 8),
//             Text(
//               appointmentTime,
//               style: AppTextStyles.f14.copyWith(color: Colors.grey),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class LastAppointmentCard extends StatelessWidget { // غيرت الاسم ليكون أوضح
//   final String? doctorImage; // يمكن أن تكون الصورة null
//   final String doctorName;
//   final String? doctorSpecialty; // يمكن أن يكون التخصص null
//   final DateTime appointmentDate;
//   final String appointmentTime; // أضفت الوقت ليتوافق مع بيانات الحجز
//
//   const LastAppointmentCard({
//     super.key,
//     this.doctorImage, // ممكن تكون null
//     required this.doctorName,
//     this.doctorSpecialty, // ممكن تكون null
//     required this.appointmentDate,
//     required this.appointmentTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 131,
//       width: 355,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         // يمكنك إضافة shadow هنا لو أردتِ
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // صورة الدكتور (NetworkImage إذا كانت من URL، أو AssetImage إذا كانت محلية)
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundImage: doctorImage != null && doctorImage!.isNotEmpty
//                       ? NetworkImage(doctorImage!) as ImageProvider
//                       : const AssetImage('assets/images/default_doctor.png'), // صورة افتراضية
//                   onBackgroundImageError: (_, __) {
//                     // يمكنك طباعة رسالة خطأ هنا أو إظهار placeholder بديل
//                     print('Error loading doctor image: $doctorImage');
//                   },
//                 ),
//                 const SizedBox(width: 16), // زيادة المسافة لتبدو أفضل
//                 Expanded( // استخدام Expanded ليأخذ الاسم والتخصص المساحة المتاحة
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         doctorName, // أصبح doctorName مطلوبًا وليس null
//                         style: AppTextStyles.f16.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       if (doctorSpecialty != null && doctorSpecialty!.isNotEmpty) // عرض التخصص فقط إذا كان موجودًا
//                         Text(
//                           doctorSpecialty!,
//                           style: AppTextStyles.f14.copyWith(fontSize: 12, color: Colors.grey[600]), // لون رمادي للتخصص
//                         ),
//                     ],
//                   ),
//                 ),
//                 // const SizedBox(width: 90), // هذه المساحة لم تعد ضرورية مع Expanded
//                 GestureDetector(
//                   onTap: () {
//                     // TODO: أضيفي منطق فتح المحادثة هنا
//                     print('Message icon tapped for $doctorName');
//                   },
//                   child: Container(
//                     width: 38,
//                     height: 38,
//                     decoration: BoxDecoration(
//                       color: ColorsApp.color1, // استخدام اللون من ColorsApp
//                       borderRadius: BorderRadius.circular(20),
//                       // تأكدي من وجود الصورة في المسار الصحيح بـ pubspec.yaml
//                       image: const DecorationImage(
//                         image: AssetImage("assets/images/messages-3.png"), // تأكد من مسار الصورة
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             // تمرير التاريخ والوقت إلى Time widget
//             Time(appointmentDate: appointmentDate, appointmentTime: appointmentTime),
//           ],
//         ),
//       ),
//     );
//   }
// }