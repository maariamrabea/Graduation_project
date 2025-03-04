import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:intl/intl.dart';

class Time extends StatelessWidget {
  final DateTime appointmentDate;

  const Time({super.key, required this.appointmentDate});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, d MMM').format(appointmentDate);
    String formattedTime = DateFormat('h:mm a').format(appointmentDate);

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0x91E3EDF2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 25),

              Icon(Icons.calendar_today, size: 14, color: ColorsApp.color1),
              SizedBox(width: 10),

              Text(
                formattedDate, // "Monday, 2 Feb"
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.color1,
                ),
              ),
              SizedBox(width: 10,),

            ],
          ),
SizedBox(width: 20,),
          Container(height: 25, width: 1, color: ColorsApp.color1),
          SizedBox(width: 30,),

          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: ColorsApp.color1),
              SizedBox(width: 8),
              Text(
                formattedTime, // "9:00 AM"
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.color1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
