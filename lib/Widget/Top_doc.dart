import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

class Top_Doctor extends StatelessWidget {
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Sara Mohamed",
      "rating": 3.9,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Youssef Khaled",
      "rating": 5.5,
      "image": "images/Rectangle 12.png",
    },
    {
      "name": "Dr. Mona Hassan",
      "rating": 2.2,
      "image": "images/Rectangle 12.png",
    },   {
      "name": "Dr. Mona Hassan",
      "rating": 2.2,
      "image": "images/Rectangle 12.png",
    },   {
      "name": "Dr. Mona Hassan",
      "rating": 2.2,
      "image": "images/Rectangle 12.png",
    },   {
      "name": "Dr. Mona Hassan",
      "rating": 2.2,
      "image": "images/Rectangle 12.png",
    },   {
      "name": "Dr. Mona Hassan",
      "rating": 2.2,
      "image": "images/Rectangle 12.png",
    },   {
      "name": "Dr. Mona Hassan",
      "rating": 2.2,
      "image": "images/Rectangle 12.png",
    },
  ];

  Top_Doctor({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(), // منع التمرير الداخلي
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Container(

            width: 163,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    doctors[index]["image"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          doctors[index]["rating"].floor(),
                              (starIndex) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                        )..addAll(
                          doctors[index]["rating"] % 1 != 0
                              ? [Icon(Icons.star_half, color: Colors.amber, size: 18)]
                              : [],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        doctors[index]["name"],
                        style: AppTextStyles.f14.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF577C8E),
                          minimumSize: Size(double.infinity, screenHeight * 0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Book Now",
                          style: AppTextStyles.f18.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }}