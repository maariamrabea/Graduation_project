import 'package:flutter/material.dart';

import '../BottomNavBarDoctor.dart';
import '../Widget/name_doc_profile.dart';
import 'CustomerSupportPage.dart';
import 'EditProfilePage.dart';
import 'FAQPage.dart';
import 'RemindersPage.dart';

class Doctorprofile extends StatefulWidget {
  const Doctorprofile({super.key});

  @override
  State<Doctorprofile> createState() => _DoctorprofileState();
}

class _DoctorprofileState extends State<Doctorprofile> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: name_doc_profile()
            ),
            const SizedBox(height: 30),
            const Text(
              'My Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
            ),
            _buildTile(
              icon: Icons.notifications_outlined,
              title: 'All Reminders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RemindersPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.language,
              title: 'Language',
              trailing: const Text('English'),
              onTap: () {},
            ),
            const SizedBox(height: 30),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.question_answer_outlined,
              title: 'FAQs',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
            ),
            _buildTile(
              icon: Icons.headphones,
              title: 'Customer Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerSupportPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon), // ← لا يوجد لون مخصص هنا
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
