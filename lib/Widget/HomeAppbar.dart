import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

import '../Screenappbar/chatpot.dart';
import 'con_Icon.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * (380 / screenWidth),
      height: screenHeight * (60 / screenHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: Image.asset("images/Ellipse 1.png")),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello", style: AppTextStyles.f14.copyWith(fontSize: 16)),
              Text("Mariam", style: AppTextStyles.f18.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(width: 130),

          SmallImageContainer(
            image: AssetImage("images/Chatbot.png"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
            },
          ),
          SizedBox(width: 15),
          SmallImageContainer(
            image: AssetImage("images/notification.png"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
