import 'package:flutter/material.dart';
import 'package:graduationproject/fontstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Map<String, String>> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reminders =
          [
            for (int i = 0; i < prefs.getKeys().length; i++)
              if (prefs.getKeys().elementAt(i).startsWith('doctor_name'))
                {
                  'doctor_name': prefs.getString('doctor_name') ?? 'Unknown',
                  'location': 'Cairo, Egypt', // يمكن تعديله من الـAPI لاحقًا
                  'date':
                      DateTime.parse(
                        prefs.getString('appointment_date') ??
                            DateTime.now().toIso8601String(),
                      ).day.toString(),
                  'month': _getMonthName(
                    DateTime.parse(
                      prefs.getString('appointment_date') ??
                          DateTime.now().toIso8601String(),
                    ).month,
                  ),
                  'time': prefs.getString('appointment_time') ?? '9:00 AM',
                },
          ].reversed.toList(); // عكس القائمة عشان الجديد يظهر في الأعلى
    });
  }

  Future<void> _deleteReminder(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('doctor_name');
    await prefs.remove('doctor_image');
    await prefs.remove('appointment_date');
    await prefs.remove('appointment_time');
    _loadReminders();
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
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
        title:  Text(
          'Reminders',
          style: AppTextStyles.f18.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF557C91),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${reminder['date']}\n${reminder['month']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              title: Text(
                reminder['doctor_name'] ?? 'Unknown',
                style: AppTextStyles.f18.copyWith(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder['location'] ?? 'Unknown'),

                  Container(
                    width: 72,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF9FCDE3), // لون أزرق فاتح زي الصورة
                      borderRadius: BorderRadius.circular(12), // زوايا مدورة
                    ),
                    child: Center(child: Text(reminder['time'] ?? 'Unknown')),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: () => _deleteReminder(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
