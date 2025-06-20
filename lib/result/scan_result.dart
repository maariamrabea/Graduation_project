import 'dart:convert'; // لتحويل JSON
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/ApiConstants.dart';
import 'package:graduationproject/result/scan_result_details.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/ElevatedButton.dart';
import '../Widget/arrow_back.dart';
import '../dio_helper.dart';
import '../fontstyle.dart';
import '../screen buttonbar/doctor Screen.dart';
//
// class ScanResult extends StatefulWidget {
//   final XFile imageFile;
//
//   const ScanResult({Key? key, required this.imageFile}) : super(key: key);
//
//   @override
//   _ScanResultState createState() => _ScanResultState();
// }
//
// class _ScanResultState extends State<ScanResult> {
//   late Future<Map<String, dynamic>> result;
//
//   @override
//   void initState() {
//     super.initState();
//     result = uploadImage(widget.imageFile);
//   }
//
//   Future<Map<String, dynamic>> uploadImage(XFile imageFile) async {
//     try {
//       print("Image path: ${imageFile.path}");
//       File file = File(imageFile.path);
//       if (!await file.exists()) {
//         print("Error: Image file does not exist at ${imageFile.path}");
//         return {
//           'result': 'Error: Image file not found',
//           'doctor': 'No doctor assigned',
//           'disease_name': 'Unknown',
//           'disease_description': 'No description available',
//           'probability': '0%',
//         };
//       }
//
//       int fileSize = await file.length();
//       print("File size: ${fileSize / 1024} KB");
//
//       File compressedFile = await compressImage(file);
//       print("Compressed file path: ${compressedFile.path}");
//       print(
//         "Compressed file size: ${(await compressedFile.length()) / 1024} KB",
//       );
//
//       FormData formData = FormData.fromMap({
//         "image": await MultipartFile.fromFile(
//           compressedFile.path,
//           filename: "scan.jpg",
//         ),
//       });
//
//       print("FormData files: ${formData.files}");
//
//       var response = await DioHelper.dio.post(
//         ApiConstants.scan_result,
//         data: formData,
//         options: Options(headers: {'Content-Type': 'multipart/form-data'}),
//       );
//
//       print("Response status: ${response.statusCode}");
//       print("Response data: ${response.data}");
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         Map<String, dynamic> data = {
//           'result': 'Diagnosis completed',
//           'doctor': 'No doctor assigned',
//           'disease_name': response.data['disease']['name'] ?? 'Unknown disease',
//           'disease_description':
//               response.data['disease']['description'] ??
//               'No description available',
//           'probability':
//               '${(response.data['probability'] * 100).toStringAsFixed(2)}%',
//           'symptoms':
//               response.data['disease']['symptoms'] ?? 'No symptoms available',
//           'causes': response.data['disease']['causes'] ?? 'No causes available',
//           'prevention':
//               response.data['disease']['prevention'] ??
//               'No prevention available',
//           'image_path': imageFile.path,
//           'date': DateTime.now().toIso8601String(), // حفظ التاريخ
//         };
//
//         final prefs = await SharedPreferences.getInstance();
//         List<String> history = prefs.getStringList('scan_history') ?? [];
//         Map<String, dynamic> scanData = {
//           'image_path': imageFile.path,
//           'disease_name': data['disease_name'],
//           'date': data['date'],
//           'case_id':
//               'Case #${DateTime.now().millisecondsSinceEpoch % 1000 + 123}', // رقم عشوائي
//         };
//         history.insert(0, jsonEncode(scanData)); // أضف الحالة الجديدة في الأول
//         if (history.length > 4) history.removeLast(); // احتفظ بـ 4 حالات فقط
//         await prefs.setStringList('scan_history', history);
//
//         return data;
//       } else {
//         return {
//           'result': 'Error: ${response.statusCode}',
//           'doctor': 'No doctor assigned',
//           'disease_name': 'Unknown',
//           'disease_description': 'No description available',
//           'probability': '0%',
//         };
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       if (e is DioError) {
//         print("Dio error type: ${e.type}");
//         print("Dio error message: ${e.message}");
//         print("Dio response: ${e.response?.data}");
//         print("Dio status code: ${e.response?.statusCode}");
//       }
//       return {
//         'result': 'Error uploading image: $e',
//         'doctor': 'No doctor assigned',
//         'disease_name': 'Unknown',
//         'disease_description': 'No description available',
//         'probability': '0%',
//       };
//     }
//   }
//
//   Future<File> compressImage(File file) async {
//     try {
//       final image = img.decodeImage(await file.readAsBytes());
//       if (image == null) {
//         print("Error: Could not decode image");
//         return file;
//       }
//       final compressedImage = img.encodeJpg(image, quality: 85);
//       final newPath = file.path.replaceAll(
//         RegExp(r'\.[^\.]+$'),
//         '_compressed.jpg',
//       );
//       final compressedFile = File(newPath)..writeAsBytesSync(compressedImage);
//       print("Compressed image saved at: $newPath");
//       return compressedFile;
//     } catch (e) {
//       print("Error compressing image: $e");
//       return file;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: CustomIconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Colors.black,
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           "Scan Result",
//           style: AppTextStyles.f18.copyWith(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<Map<String, dynamic>>(
//           future: result,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             } else if (snapshot.hasData) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 200,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 6,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         File(widget.imageFile.path),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     snapshot.data!['disease_name']!,
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Probability: ${snapshot.data!['probability']}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     snapshot.data!['disease_description']!,
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                     textAlign: TextAlign.center,
//                   ),
//                   Spacer(),
//                   Elevated_Button(
//
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => ScanResultDetails(
//                                 diseaseName: snapshot.data!['disease_name'],
//                                 probability: snapshot.data!['probability'],
//                                 symptoms: snapshot.data!['symptoms'],
//                                 causes: snapshot.data!['causes'],
//                                 prevention: snapshot.data!['prevention'],
//                               ),
//                         ),
//                       );
//                     },
//                    text:
//                       'More Details',
//
//                   ),
//                   SizedBox(height: 10),
//                   Elevated_Button(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => DoctorScreen()),
//                       );
//                     },
//                     text: 'Book a Doctor',
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               );
//             } else {
//               return Center(child: Text("No result available"));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


class ScanResult extends StatefulWidget {
  final XFile imageFile;

  const ScanResult({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  late Future<Map<String, dynamic>> result;

  @override
  void initState() {
    super.initState();
    result = uploadImage(widget.imageFile);
  }

  Future<Map<String, dynamic>> uploadImage(XFile imageFile) async {
    try {
      print("Image path: ${imageFile.path}");
      File file = File(imageFile.path);
      if (!await file.exists()) {
        print("Error: Image file does not exist at ${imageFile.path}");
        return {
          'result': 'Error: Image file not found',
          'doctor': 'No doctor assigned',
          'disease_name': 'Unknown',
          'disease_description': 'No description available',
          'probability': '0%',
        };
      }

      int fileSize = await file.length();
      print("File size: ${fileSize / 1024} KB");

      File compressedFile = await compressImage(file);
      print("Compressed file path: ${compressedFile.path}");
      print("Compressed file size: ${(await compressedFile.length()) / 1024} KB");

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          compressedFile.path,
          filename: "scan.jpg",
        ),
      });

      print("FormData files: ${formData.files}");

      var response = await DioHelper.dio.post(
        ApiConstants.scan_result,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> data = {
          'result': 'Diagnosis completed',
          'doctor': 'No doctor assigned',
          'disease_name': response.data['disease']['name'] ?? 'Unknown disease',
          'disease_description':
          response.data['disease']['description'] ?? 'No description available',
          'probability':
          '${(response.data['probability'] * 100).toStringAsFixed(2)}%',
          'symptoms': response.data['disease']['symptoms'] ?? 'No symptoms available',
          'causes': response.data['disease']['causes'] ?? 'No causes available',
          'prevention':
          response.data['disease']['prevention'] ?? 'No prevention available',
          'image_path': imageFile.path,
          'date': DateTime.now().toIso8601String(),
        };

        final prefs = await SharedPreferences.getInstance();
        List<String> history = prefs.getStringList('scan_history') ?? [];
        int caseNumber = history.length + 1; // الرقم الترتيبي بناءً على عدد الحجوزات
        Map<String, dynamic> scanData = {
          'image_path': imageFile.path,
          'disease_name': data['disease_name'],
          'date': data['date'],
          'case_id': 'Case #$caseNumber',
        };
        history.insert(0, jsonEncode(scanData));
        if (history.length > 4) history.removeLast();
        await prefs.setStringList('scan_history', history);

        return data;
      } else {
        return {
          'result': 'Error: ${response.statusCode}',
          'doctor': 'No doctor assigned',
          'disease_name': 'Unknown',
          'disease_description': 'No description available',
          'probability': '0%',
        };
      }
    } catch (e) {
      print("Error uploading image: $e");
      if (e is DioError) {
        print("Dio error type: ${e.type}");
        print("Dio error message: ${e.message}");
        print("Dio response: ${e.response?.data}");
        print("Dio status code: ${e.response?.statusCode}");
      }
      return {
        'result': 'Error uploading image: $e',
        'doctor': 'No doctor assigned',
        'disease_name': 'Unknown',
        'disease_description': 'No description available',
        'probability': '0%',
      };
    }
  }

  Future<File> compressImage(File file) async {
    try {
      final image = img.decodeImage(await file.readAsBytes());
      if (image == null) {
        print("Error: Could not decode image");
        return file;
      }
      final compressedImage = img.encodeJpg(image, quality: 85);
      final newPath = file.path.replaceAll(
        RegExp(r'\.[^\.]+$'),
        '_compressed.jpg',
      );
      final compressedFile = File(newPath)..writeAsBytesSync(compressedImage);
      print("Compressed image saved at: $newPath");
      return compressedFile;
    } catch (e) {
      print("Error compressing image: $e");
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Scan Result",
          style: AppTextStyles.f18.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: result,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(widget.imageFile.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    snapshot.data!['disease_name']!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Probability: ${snapshot.data!['probability']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data!['disease_description']!,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Elevated_Button(

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanResultDetails(
                            diseaseName: snapshot.data!['disease_name'],
                            probability: snapshot.data!['probability'],
                            symptoms: snapshot.data!['symptoms'],
                            causes: snapshot.data!['causes'],
                            prevention: snapshot.data!['prevention'],
                          ),
                        ),
                      );
                    },
                    text:
                      'More Details',

                  ),
                  SizedBox(height: 10),
                  Elevated_Button(

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorScreen()),
                      );
                    },
                    text:
                      'Book a Doctor',

                  ),
                  SizedBox(height: 20),
                ],
              );
            } else {
              return Center(child: Text("No result available"));
            }
          },
        ),
      ),
    );
  }
}
