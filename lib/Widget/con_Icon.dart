import 'package:flutter/material.dart';

class SmallImageContainer extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback onTap;

  const SmallImageContainer({
    required this.image,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * (36 / screenWidth),
        height: screenHeight * (36 / screenHeight),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: image,
            //  fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
