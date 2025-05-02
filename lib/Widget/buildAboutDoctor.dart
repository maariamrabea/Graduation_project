import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fontstyle.dart';

  _buildAboutDoctor() {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Text(
         "About Doctor",
         style: AppTextStyles.f16.copyWith(
           color: Colors.black,
           fontWeight: FontWeight.w400,
         ),
       ),
       SizedBox(height: 10),
       Text(
         "Medical specialist who diagnoses and treats skin, hair, and nail conditions. Help manage issues like acne and skin cancer through medical treatment.",
         style: AppTextStyles.f14,
       ),
       SizedBox(height: 40),
       Text(
         "Working Time",
         style: AppTextStyles.f16.copyWith(
           color: Colors.black,
           fontWeight: FontWeight.w400,
         ),
       ),
       SizedBox(height: 10),
       Text("Sunday - Monday, 9:00 AM To 11 PM.", style: AppTextStyles.f14),
       SizedBox(height: 40),
       Text(
         "Contact",
         style: AppTextStyles.f16.copyWith(
           color: Colors.black,
           fontWeight: FontWeight.w400,
         ),
       ),
       SizedBox(height: 10),
       Text("+20 111 694 2750", style: AppTextStyles.f14),
     ],
   );
 }
