import 'package:flutter/material.dart';

import '../Widget/arrow_back.dart';
import '../fontstyle.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I accept or reject an appointment request?',
      'answer':
      'To manage appointment requests  \n 1- Go to the "Appointments" section from the bottom navigation bar.\n 2- Under the "Upcoming" tab, you will find new patient Appointments.\n\n- Tap Accept to confirm the booking.\n Or \n- Tap Cancel to remove it after confirmation.',
    },
    {
      'question': 'Where can I see all the appointments I’ve accepted?',
      'answer':
      'Accepted appointments are shown in the "Accepted" tab on the Appointments screen. You can also view a summary of them in the "Reminders" section under your profile.',
    },
    {
      'question': 'Can I update my personal details such as name or specialty?',
      'answer':
      'Yes. To edit your profile: \n  1- Go to the "Profile" tab \n 2- Tap on "Edit Profile".\n You can update your name, contact information, and specialty from there.',
    },
  ];

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
        backgroundColor: ColorsApp.color1,
        title: Text(
          "FAQ",
          style: AppTextStyles.f18.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              title: Text(
                faqs[index]['question']!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    faqs[index]['answer']!,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}