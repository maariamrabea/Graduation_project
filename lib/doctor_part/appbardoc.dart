import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../Screenappbar/chatpot.dart';
import '../Widget/con_Icon.dart';
import '../dio_helper.dart';
import '../fontstyle.dart';

class Appbardoc extends StatefulWidget {
  const Appbardoc({super.key});

  @override
  _AppbardocState createState() => _AppbardocState();
}

class _AppbardocState extends State<Appbardoc> {
  String? fullname;
  String? profilePictureUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.dio.get(
        '${ApiConstants.dio}api/users/profile/',
      );
      if (response.statusCode == 200) {
        setState(() {
          final fullName = response.data['full_name'] ?? 'User';
          fullname = fullName; // أخذ الاسم الأول بس
          profilePictureUrl = response.data['profile_picture_url'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (e is DioException) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        print('Dio Error: ${e.response?.data}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * (360 / screenWidth),
      height: screenHeight * (60 / screenHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(left: 5)),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
                  profilePictureUrl != null && !isLoading
                      ? DecorationImage(
                        image: NetworkImage(profilePictureUrl!),
                        fit: BoxFit.cover,
                        onError:
                            (exception, stackTrace) =>
                                Container(color: Colors.grey[300]),
                      )
                      : null,
              color:
                  isLoading || profilePictureUrl == null
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
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello", style: AppTextStyles.f14.copyWith(fontSize: 16)),
              Text(
                fullname ?? 'User',
                style: AppTextStyles.f18.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              SizedBox(height: 10),
              SmallImageContainer(
                image: AssetImage("images/notification.png"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBotScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
