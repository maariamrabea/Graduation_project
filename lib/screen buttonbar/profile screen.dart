import 'package:flutter/material.dart';

import '../fontstyle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          iconSize: 35.0,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[150],

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/doctor image 3.jpeg',
                      ), // استبدل بعنوان URL الخاص بصورة الملف الشخصي
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mariam',
                      style: AppTextStyles.f18.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        'My Account',

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // إضافة وظيفة تعديل الملف الشخصي هنا
                },
              ),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('All Reminders'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // إضافة وظيفة التذكيرات هنا
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('English'), Icon(Icons.chevron_right)],
                ),
                onTap: () {
                  // إضافة وظيفة تغيير اللغة هنا
                },
              ),

              const SizedBox(height: 20),
              const Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(Icons.question_answer_outlined),
                title: const Text('FAQS'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // إضافة وظيفة الأسئلة الشائعة هنا
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
