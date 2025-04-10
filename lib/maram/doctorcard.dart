import 'package:flutter/material.dart';

class Doctorcard extends StatelessWidget {
  const Doctorcard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.white,
      shadowColor: Colors.grey,
      borderOnForeground: true,
      elevation: 2.5,

      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                'assets/doctor image for circle avatar.jpg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
