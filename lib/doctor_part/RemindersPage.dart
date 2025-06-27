import 'package:flutter/material.dart';

import '../Widget/arrow_back.dart';
import '../fontstyle.dart';
import 'AcceptedPage.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

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
          "Reminders",
          style: TextStyle(fontWeight: FontWeight.normal),

        ),
        centerTitle: true,
      ),
      body:
      acceptedBookings.isEmpty
          ? const Center(child: Text('No reminders found.'))
          : ListView.builder(
        itemCount: acceptedBookings.length,
        itemBuilder: (context, index) {
          final booking = acceptedBookings[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Image.asset(
                'assets/user (2).png',
                width: 40,
                height: 40,
              ),
              title: Text(
                booking['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${booking['date']} at ${booking['time']}',
              ),
            ),
          );
        },
      ),
    );
  }
}