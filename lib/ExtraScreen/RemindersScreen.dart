import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // افتراضي إنك تستخدمي Dio
import 'package:intl/intl.dart'; // لتنسيق التاريخ والوقت
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart'; // لـ token

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Map<String, dynamic>> reminders = []; // يحتوي على booking_id
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        throw Exception('No access token found');
      }

      final response = await DioHelper.getWithAuthRequest(
        '${ApiConstants.dio}api/patients/bookings/accepted/', // غير الـendpoint حسب احتياجاتك
      );

      if (response.statusCode == 200) {
        try {
          final data = response.data;
          print('Response data: $data'); // طباعة البيانات عشان نشوف الهيكل

          List<dynamic> bookings = [];
          if (data is List) {
            bookings = data;
          } else if (data is Map && data.containsKey('data')) {
            bookings = data['data'] as List? ?? [];
          } else if (data is Map && data.containsKey('results')) {
            bookings = data['results'] as List? ?? [];
          } else {
            bookings = [];
          }

          setState(() {
            reminders = bookings.map((booking) {
              final doctor = booking['doctor'] ?? {};
              final bookingDate = booking['booking_date'] ?? DateTime.now().toIso8601String();
              final bookingTime = booking['booking_time'] ?? '09:00:00';

              return {
                'booking_id': booking['id']?.toString() ?? '', // إضافة booking_id
                'doctor_name': doctor['full_name'] ?? 'Unknown',
                'location': booking['location'] ?? 'Cairo, Egypt',
                'date': _parseDate(bookingDate).day.toString(),
                'month': _getMonthName(_parseDate(bookingDate).month),
                'time': _formatTime(bookingTime),
              };
            }).toList().reversed.toList(); // عكس القائمة عشان الجديد يظهر في الأعلى
            isLoading = false;
          });
        } catch (e) {
          setState(() {
            errorMessage = 'Error processing reminders: $e';
            isLoading = false;
          });
          print('Processing error details: $e');
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load reminders: ${response.statusCode} - ${response.data}';
          isLoading = false;
        });
        print('API error: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading reminders: $e';
        isLoading = false;
      });
      print('Load reminders error details: $e');
    }
  }

  Future<void> _deleteReminder(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        throw Exception('No access token found');
      }

      final bookingId = reminders[index]['booking_id'];
      if (bookingId == null || bookingId.isEmpty) {
        throw Exception('No booking ID found for reminder');
      }

      final response = await DioHelper.patchWithAuthRequest(
        '${ApiConstants.dio}api/patients/bookings/${bookingId}/cancel/',
        data: {'status': 'cancelled'},
      );

      if (response.statusCode == 200) {
        setState(() {
          reminders.removeAt(index);
        });
      } else {
        throw Exception('Failed to cancel reminder: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error cancelling reminder: $e';
      });
      print('Delete reminder error details: $e');
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Date parsing error for $dateStr: $e');
      return DateTime.now();
    }
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  String _formatTime(String timeStr) {
    try {
      final time = DateFormat('HH:mm:ss').parse(timeStr);
      return DateFormat('h:mm a').format(time);
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          'Reminders',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : reminders.isEmpty
          ? Center(child: Text('No reminders available'))
          : ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2, // إضافة ظل خفيف زي الصورة
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Container(
                width: 100, // مطابق للصورة
                height: 80, // مطابق للصورة
                decoration: BoxDecoration(
                  color: const Color(0xFF557C91), // اللون الأزرق الغامق
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${reminder['date']}\n${reminder['month']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold, // زيادة الوضوح
                    ),
                  ),
                ),
              ),
              title: Text(
                reminder['doctor_name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // زي الصورة
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4), // مسافة بسيطة
                  Text(
                    reminder['location'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey, // لون رمادي زي الصورة
                    ),
                  ),
                  const SizedBox(height: 8), // مسافة بين الموقع والوقت
                  Container(
                    width: 72, // مطابق للصورة
                    height: 30, // مطابق للصورة
                    decoration: BoxDecoration(
                      color: const Color(0xFF9FCDE3), // اللون الأزرق الفاتح
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        reminder['time'] ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey), // لون أحمر زي الصورة
                onPressed: () => _deleteReminder(index),
              ),
            ),
          );
        },
      ),
    );
  }
}