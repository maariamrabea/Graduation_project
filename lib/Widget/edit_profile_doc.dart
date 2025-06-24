import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import '../fontstyle.dart';

class edit_doc_profile extends StatefulWidget {
  const edit_doc_profile({super.key});

  @override
  _edit_doc_profileState createState() => _edit_doc_profileState();
}

class _edit_doc_profileState extends State<edit_doc_profile> {
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
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      height: screenHeight * (252 / screenHeight),
      width: screenWidth * (270 / screenWidth),

      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Padding(padding: EdgeInsets.only(left: 5)),
      Container(
        width: 128,
        height: 128,
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

      Text(
          fullname ?? 'User',
          style: AppTextStyles.f24),
    ]
    ,
    )
    ,
    )
    ,
    );
  }
}
