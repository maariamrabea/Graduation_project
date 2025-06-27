import 'package:flutter/material.dart';

import '../Widget/arrow_back.dart';
import '../fontstyle.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(
              context,

            );
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Notification", style: AppTextStyles.f18.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
      ),      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Today',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Doctor Appointment'),
              subtitle: Text("Don't forget your appointment 11:30 AM"),
              trailing: Text('11:30 AM'),
            ),
          ),
          Card(
            color: Colors.white,

            child: ListTile(
              leading: Icon(Icons.message),
              title: Text('New Message'),
              subtitle: Text('You have a new message'),
              trailing: Text('11:30 AM'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Yesterday',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            color: Colors.white,

            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Doctor Appointment'),
              subtitle: Text("Don't forget your appin..."),
              trailing: Text('11:30 AM'),
            ),
          ),
        ],
      ),
    );
  }
}
