import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';

import '../ApiConstants.dart';
import '../ExtraScreen/DoctorDetailScreen.dart';
import '../Widget/RatingExperienceWidget.dart';
import '../Widget/arrow_back.dart';
import '../dio_helper.dart';

//
//
// class DoctorScreen extends StatefulWidget {
//   @override
//   _DoctorScreenState createState() => _DoctorScreenState();
// }
//
// class _DoctorScreenState extends State<DoctorScreen> {
//   List<Map<String, dynamic>> allDoctors = []; // القائمة الأصلية لكل الأطباء
//   List<Map<String, dynamic>> filteredDoctors = []; // القائمة المفلترة
//   TextEditingController searchController = TextEditingController();
//   late Future<List<Map<String, dynamic>>> futureDoctors;
//
//   @override
//   void initState() {
//     super.initState();
//     futureDoctors = fetchDoctors();
//     futureDoctors.then((data) {
//       setState(() {
//         allDoctors = data;
//         filteredDoctors = data; // ابدأ بكل الأطباء
//       });
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> fetchDoctors() async {
//     try {
//       print('Fetching from: ${ApiConstants.dio}api/doctors/list/');
//       final response = await DioHelper.dio.get(
//         '${ApiConstants.dio}api/doctors/list/',
//       );
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data;
//         return data.map((json) {
//           return {
//             "name": json['user']['full_name'],
//             "rating": json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
//             "image": json['user']['profile_picture'] ?? '',
//             "price": "${json['booking_price']} EGP",
//             "experience": "${json['experience_years']}Y",
//             "patients": "${json['patients']}",
//             "workingTime": json['working_hours'],
//             "contact": json['clinic_phone'],
//             "description": json['about'],
//           };
//         }).toList();
//       } else {
//         throw Exception(
//             'Failed to load doctors: ${response.statusCode} ${response.data}');
//       }
//     } catch (e) {
//       if (e is DioException) {
//         print('Dio Error: ${e.response?.statusCode} ${e.response?.data}');
//       }
//       throw Exception('Error fetching doctors: $e');
//     }
//   }
//
//   void filterSearch(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredDoctors = List.from(allDoctors); // رجوع لكل الأطباء لو الفضاء فاضي
//       });
//     } else {
//       setState(() {
//         filteredDoctors = allDoctors
//             .where((doctor) =>
//             doctor["name"].toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: CustomIconButton(
//           onPressed: () {
//             Navigator.pop(
//               context,
//               // MaterialPageRoute(builder: (context) => BottomBar()),
//             );
//           },
//           color: Colors.black,
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           "Doctor",
//           style: AppTextStyles.f18.copyWith(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             TextField(
//               controller: searchController,
//               onChanged: (query) => filterSearch(query), // تحديث الفلترة عند التغيير
//               decoration: InputDecoration(
//                 labelText: 'Search Doctors',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: futureDoctors,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(
//                       child: Text(
//                         "No doctor found",
//                         style: TextStyle(fontSize: 18, color: Colors.grey),
//                       ),
//                     );
//                   }
//                   // تحديث allDoctors فقط لو لسه فاضية
//                   if (allDoctors.isEmpty) {
//                     allDoctors = snapshot.data!;
//                     filteredDoctors = snapshot.data!;
//                   }
//                   return filteredDoctors.isEmpty
//                       ? Center(
//                     child: Text(
//                       "No doctor found",
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   )
//                       : ListView.builder(
//                     itemCount: filteredDoctors.length,
//                     itemBuilder: (context, index) {
//                       final doctor = filteredDoctors[index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DoctorDetailScreen(
//                                 doctorName: doctor["name"],
//                                 doctorImage: doctor["image"],
//                                 contact: doctor['contact'],
//                                 workingTime: doctor['workingTime'],
//                               ),
//                             ),
//                           );
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
//                           child: Container(
//                             height: 106,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.white,
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(10),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         height: 40,
//                                         width: 40,
//                                         child: doctor["image"] != null &&
//                                             doctor["image"]
//                                                 .isNotEmpty
//                                             ? Image.network(
//                                           doctor["image"],
//                                           fit: BoxFit.cover,
//                                           errorBuilder: (context,
//                                               error, stackTrace) {
//                                             print(
//                                                 'Image load error for ${doctor["image"]}: $error');
//                                             return Icon(
//                                               Icons.person,
//                                               color: Colors.grey,
//                                               size: 40,
//                                             );
//                                           },
//                                         )
//                                             : Icon(
//                                           Icons.person,
//                                           color: Colors.grey,
//                                           size: 40,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Expanded(
//                                         child: Text(
//                                           doctor["name"],
//                                           style: TextStyle(fontSize: 16),
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                       SizedBox(width: 20),
//                                       Text(
//                                         doctor["price"],
//                                         style: TextStyle(
//                                           color: ColorsApp.color1,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 20),
//                                   RatingExperienceWidget(
//                                     rating: doctor["rating"],
//                                     patients:
//                                     doctor["patients"] + " Patient",
//                                     experience: doctor["experience"],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<Map<String, dynamic>> allDoctors = []; // القائمة الأصلية لكل الأطباء
  List<Map<String, dynamic>> filteredDoctors = []; // القائمة المفلترة
  TextEditingController searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> futureDoctors;

  @override
  void initState() {
    super.initState();
    futureDoctors = fetchDoctors();
    futureDoctors.then((data) {
      setState(() {
        allDoctors = data;
        filteredDoctors = data; // ابدأ بكل الأطباء
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      print('Fetching from: ${ApiConstants.dio}api/doctors/list/');
      final response = await DioHelper.dio.get(
        '${ApiConstants.dio}api/doctors/list/',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          return {
            "id": json['user']['id'] as int, // تأكيد إن id بيكون int
            "name": json['user']['full_name'],
            "rating":
                json['rating'] != null
                    ? double.parse(json['rating'].toString())
                    : 0.0,
            "image": json['user']['profile_picture'] ?? '',
            "price": "${json['booking_price']} EGP",
            "experience": "${json['experience_years']}Y",
            "patients": "${json['patients']}",
            "workingTime": json['working_hours'],
            "contact": json['clinic_phone'],
            "description": json['about'],
          };
        }).toList();
      } else {
        throw Exception(
          'Failed to load doctors: ${response.statusCode} ${response.data}',
        );
      }
    } catch (e) {
      if (e is DioException) {
        print('Dio Error: ${e.response?.statusCode} ${e.response?.data}');
      }
      throw Exception('Error fetching doctors: $e');
    }
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDoctors = List.from(
          allDoctors,
        ); // رجوع لكل الأطباء لو الفضاء فاضي
      });
    } else {
      setState(() {
        filteredDoctors =
            allDoctors
                .where(
                  (doctor) => doctor["name"].toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(
              context,
              // MaterialPageRoute(builder: (context) => BottomBar()),
            );
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Doctor",
          style: AppTextStyles.f18.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (query) => filterSearch(query),
              // تحديث الفلترة عند التغيير
              decoration: InputDecoration(
                labelText: 'Search Doctors',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureDoctors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No doctor found",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  // تحديث allDoctors فقط لو لسه فاضية
                  if (allDoctors.isEmpty) {
                    allDoctors = snapshot.data!;
                    filteredDoctors = snapshot.data!;
                  }
                  return filteredDoctors.isEmpty
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
                                        doctorId:
                                            doctor["id"]
                                                as int, // تأكيد إن doctorId int
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
                                            child:
                                                doctor["image"] != null &&
                                                        doctor["image"]
                                                            .isNotEmpty
                                                    ? Image.network(
                                                      doctor["image"],
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        print(
                                                          'Image load error for ${doctor["image"]}: $error',
                                                        );
                                                        return Icon(
                                                          Icons.person,
                                                          color: Colors.grey,
                                                          size: 40,
                                                        );
                                                      },
                                                    )
                                                    : Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    ),
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
                                      RatingExperienceWidget(
                                        rating: doctor["rating"],
                                        patients:
                                            doctor["patients"] + " Patient",
                                        experience: doctor["experience"],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
