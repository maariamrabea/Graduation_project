import 'package:flutter/material.dart';
import 'package:graduationproject/screen%20buttonbar/HistoryScreen.dart';

import '../Widget/LastCase.dart';
import '../fontstyle.dart';

class EndBart extends StatelessWidget {
  const EndBart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Last cases",
                  style: AppTextStyles.f16.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryCases()),
                    );
                  },
                  child: Text(
                    "See all",
                    style: AppTextStyles.f18.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            Container(
              height: (screenHeight * 266) / screenHeight,
              width: screenWidth,

              child: LastCase(),
            ),

            // Top_Doctor(),
          ],
        ),
      ),
    );
  }
}
