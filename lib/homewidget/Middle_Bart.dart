import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/fontstyle.dart';

import '../Widget/time.dart';

class MiddleBart extends StatelessWidget {
  const MiddleBart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * (400 / screenHeight),
      width: screenWidth * (386 / screenWidth),
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
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        ColorsApp
                            .color1, // Replace ColorsApp.color1 with a default color
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Adds spacing between elements
          Container(
            height: 131,
            width: 343,
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
                          Text("Dr. Ahmed", style: AppTextStyles.namedoc),
                          Text(
                            "Dermatologist",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
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
                            border: Border.all(
                              color: Colors.transparent,
                            ),
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
                  SizedBox(height: 15,),
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
