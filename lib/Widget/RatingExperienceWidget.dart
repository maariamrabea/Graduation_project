 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fontstyle.dart';


 class RatingExperienceWidget extends StatelessWidget {
   final double rating;
   final String patients;
   final String experience;

   const RatingExperienceWidget({
     required this.rating,
     required this.patients,
     required this.experience,
   });

   @override
   Widget build(BuildContext context) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         _buildInfo(Icons.star, rating.toString()),
         _divider(),
         _buildInfo(Icons.person, patients),
         _divider(),
         _buildInfo(Icons.work, experience),
       ],
     );
   }

   Widget _buildInfo(IconData icon, String text) {
     return Row(
       children: [
         Icon(icon, color: ColorsApp.color1, size: 14),
         SizedBox(width: 5),
         Text(
           text,
           style: AppTextStyles.f14.copyWith(
             fontWeight: FontWeight.w400,
             fontSize: 12,
           ),
         ),
       ],
     );
   }

   Widget _divider() {
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0),
       child: Text(
         "|",
         style: TextStyle(fontSize: 12, color: Color(0xFFEEEEEE)),
       ),
     );
   }
 }