import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../Widget/arrow_back.dart';
import '../dio_helper.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullname;
  String? profilePictureUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    if (!mounted) return; // تأكد إن الـwidget لسه موجود
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.dio.get(
        '${ApiConstants.dio}api/users/profile/',
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            fullname = response.data['full_name'] ?? 'User'; // الاسم كامل
            profilePictureUrl = response.data['profile_picture_url'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
          _showSnackBar('Failed to load profile: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        if (e is DioException) {
          _showSnackBar('Error: ${e.message}');
          print('Dio Error: ${e.response?.data}');
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.normal),

        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: profilePictureUrl != null && !isLoading
                            ? DecorationImage(
                          image: NetworkImage(profilePictureUrl!),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) =>
                              Container(color: Colors.grey[300]),
                        )
                            : null,
                        color: isLoading || profilePictureUrl == null
                            ? Colors.grey[300]
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fullname ?? 'User',
                      style: TextStyle( // استبدلت AppTextStyles.f18
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2, // إضافة ظل خفيف
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _navigateTo(const EditProfileScreen());
                  },
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('All Reminders'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
               //     _navigateTo(const RemindersScreen()); // أضفت التنقل
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('English'), Icon(Icons.chevron_right)],
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.question_answer_outlined),
                  title: const Text('About Us'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _navigateTo(const AboutUsScreen());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: const Center(child: Text("Edit Profile Page")),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Our Team",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "• Mariam – UI/UX Designer\n• Manar – Backend Developer\n• Maram & Mariam – Mobile Developer\n• Menna – AI Engineer",
            ),
            SizedBox(height: 20),
            Text(
              "This app is developed for our graduation project to help users manage their medical profiles.",
            ),
          ],
        ),
      ),
    );
  }
}