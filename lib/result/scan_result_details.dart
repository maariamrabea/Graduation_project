import 'package:flutter/material.dart';

import '../Widget/arrow_back.dart';
import '../fontstyle.dart';

class ScanResultDetails extends StatelessWidget {
  final String diseaseName;
  final String probability;
  final String symptoms;
  final String causes;
  final String prevention;

  const ScanResultDetails({
    Key? key,
    required this.diseaseName,
    required this.probability,
    required this.symptoms,
    required this.causes,
    required this.prevention,
  }) : super(key: key);

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
          diseaseName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Probability: $probability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Symptoms:', style: AppTextStyles.f18),
            SizedBox(height: 10),
            ..._buildBulletPoints(symptoms),
            SizedBox(height: 20),
            Text('Causes:', style: AppTextStyles.f18),
            SizedBox(height: 10),
            ..._buildBulletPoints(causes),
            SizedBox(height: 20),
            Text('Prevention:', style: AppTextStyles.f18),
            SizedBox(height: 10),
            ..._buildBulletPoints(prevention),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBulletPoints(String text) {
    // تقسيم النص بناءً على ';' وإزالة الـ ';' من النهاية
    List<String> items =
        text
            .split(';')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();
    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontSize: 16, color: Colors.black)),
                Expanded(
                  child: Text(
                    item, // النص من غير الـ ';'
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
