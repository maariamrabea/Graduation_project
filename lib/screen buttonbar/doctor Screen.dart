import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

import '../Widget/search_bar.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Ahmed Ali",
      "rating": 4.8,
      "image": "images/Ellipse 10.png",
      "price": "200 EGP",
    },
    {
      "name": "Dr. Sara Mohamed",
      "rating": 4.7,
      "image": "images/Ellipse 10.png",
      "price": "250 EGP",
    },
    {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
    },  {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
    },  {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
    },
    {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
    },
    {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
    },
    {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
    },
    {
      "name": "Dr. Youssef Omar",
      "rating": 4.5,
      "image": "images/Ellipse 10.png",
      "price": "180 EGP",
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
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Doctors",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            CustomSearchBar(
              controller: searchController,
              onChanged: filterSearch,
            ),
            SizedBox(height: 20),
            Expanded( // ✅ يجعل القائمة تمتد وتأخذ المساحة المتاحة
              child: filteredDoctors.isEmpty
                  ? Center(
                child: Text(
                  "No doctor found",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder( // ✅ إزالة `SingleChildScrollView`
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
                    child: Container(
                      height: 106, // ✅ إزالة الحساب الديناميكي غير الضروري
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
                                  child: Image.asset(
                                    filteredDoctors[index]["image"],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded( // ✅ يسمح للنص بأخذ المساحة المناسبة
                                  child: Text(
                                    filteredDoctors[index]["name"],
                                    style: AppTextStyles.f14.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF262626),
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  filteredDoctors[index]["price"],
                                  style: AppTextStyles.f14.copyWith(
                                    color: ColorsApp.color1,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }}

class RatingExperienceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfo(Icons.star, "4.8"),
        _divider(),
        _buildInfo(Icons.person, "140 Patient"),
        _divider(),
        _buildInfo(Icons.work, "3Y Experience"),
      ],
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: ColorsApp.color1, size: 14),
        SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyles.f14.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "|",
        style: TextStyle(fontSize: 12, color: Color(0xFFEEEEEE)),
      ),
    );
  }
}
