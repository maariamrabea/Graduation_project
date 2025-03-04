import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:graduationproject/screen%20buttonbar/Chatscreen.dart';
import 'package:graduationproject/screen%20buttonbar/HomeScreen.dart';
import 'package:graduationproject/screen%20buttonbar/Scan%20screen.dart';
import 'package:graduationproject/screen%20buttonbar/doctor%20Screen.dart';
import 'package:graduationproject/screen%20buttonbar/profile%20screen.dart';

import 'ExtraScreen/beginningScan.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    DoctorScreen(),
    BeginningScan(),
    ChatScreen(),
    ProfileScreen(),
  ];

  final List<String> icons = [
    "images/home.png",
    "images/doctor.png",
    "images/scan.png",
    "images/chat.png",
    "images/profile.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorsApp.color1, // اللون عند التحديد
        unselectedItemColor: Colors.grey, // اللون عند عدم التحديد
        items: List.generate(icons.length, (index) {
          return BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == index ?  ColorsApp.color1: Colors.grey,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                icons[index],
                width: 25,
                height: 25,
              ),
            ),
            label: ["Home", "Doctor", "Scan", "Chat", "Profile"][index],
          );
        }),
      ),
    );
  }
}