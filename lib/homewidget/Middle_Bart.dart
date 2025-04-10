import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/fontstyle.dart';

import '../Widget/time.dart';
import 'endpart.dart';

class MiddleBart extends StatelessWidget {
  const MiddleBart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                onPressed: () {},
                child: Text(
                  "See all",
                  style: AppTextStyles.f18.copyWith(
                    fontSize: 12,
                  ), // Replace ColorsApp.color1 with a default color
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Adds spacing between elements
          Container(
            height: 131,
            width: 355,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(child: Image.asset("images/Ellipse 1.png")),
                      // SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. Ahmed",
                            style: AppTextStyles.f16.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Dermatologist",
                            style: AppTextStyles.f14.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(width: 90),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: ColorsApp.color1,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage("images/messages-3.png"),
                              scale: 0.9,
                              //fit: BoxFit.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Time(appointmentDate: DateTime(2025, 2, 2, 9, 0)),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
