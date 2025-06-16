import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

import '../BottomBar.dart';
import '../ExtraScreen/DoctorDetailScreen.dart';
import '../Widget/RatingExperienceWidget.dart';
import '../Widget/arrow_back.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr.David Smith",
      "rating": 4.8,
      "image": "images/Ellipse 10.png",
      "price": "200 EGP",
      "experience": "3Y",
      "patients": "140",
      "workingTime": "Sunday - Monday, 9:00 AM To 11 PM",
      "contact": "+20 111 694 2750",
      "description":
          "Specialist who diagnoses and treats skin, hair, and nail conditions.",
    },
    {
      "name": "Dr.Micheal Joe",
      "rating": 4.8,
      "image": "images/Ellipse 10 (1).png",
      "price": "200 EGP",
      "experience": "3Y",
      "patients": "140",
      "workingTime": "Sunday - Monday, 9:00 AM To 11 PM",
      "contact": "+20 111 694 2750",
      "description":
          "Specialist who diagnoses and treats skin, hair, and nail conditions.",
    },
    {
      "name": "Dr.Engy Ahmed",
      "rating": 4.8,
      "image": "images/Ellipse 10 (2).png",
      "price": "200 EGP",
      "experience": "3Y",
      "patients": "140",
      "workingTime": "Sunday - Monday, 9:00 AM To 11 PM",
      "contact": "+20 111 694 2750",
      "description":
          "Specialist who diagnoses and treats skin, hair, and nail conditions.",
    },
    {
      "name": "Dr.Amir Nabil",
      "rating": 4.8,
      "image": "images/Ellipse 10 (3).png",
      "price": "200 EGP",
      "experience": "3Y",
      "patients": "140",
      "workingTime": "Sunday - Monday, 9:00 AM To 11 PM",
      "contact": "+20 111 694 2750",
      "description":
          "Specialist who diagnoses and treats skin, hair, and nail conditions.",
    },
    {
      "name": "Dr.May Ahmed",
      "rating": 4.8,
      "image": "images/Ellipse 10 (4).png",
      "price": "200 EGP",
      "experience": "3Y",
      "patients": "140",
      "workingTime": "Sunday - Monday, 9:00 AM To 11 PM",
      "contact": "+20 111 694 2750",
      "description":
          "Specialist who diagnoses and treats skin, hair, and nail conditions.",
    },
  ];

  List<Map<String, dynamic>> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
  }

  void filterSearch(String query) {
    setState(() {
      filteredDoctors =
          doctors
              .where(
                (doctor) =>
                    doctor["name"].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(
              context,
            //  MaterialPageRoute(builder: (context) => BottomBar()),
            );
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Doctor", style: AppTextStyles.f18.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                labelText: 'Search Doctors',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  filteredDoctors.isEmpty
                      ? Center(
                        child: Text(
                          "No doctor found",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = filteredDoctors[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DoctorDetailScreen(
                                        doctorName: doctor["name"],
                                        doctorImage: doctor["image"],
                                        contact: doctor['contact'],
                                        workingTime: doctor['workingTime'],
                                      ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
                              child: Container(
                                height: 106,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(doctor["image"]),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              doctor["name"],
                                              style: TextStyle(fontSize: 16),
                                              softWrap: true,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            doctor["price"],
                                            style: TextStyle(
                                              color: ColorsApp.color1,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),

                                      RatingExperienceWidget(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
