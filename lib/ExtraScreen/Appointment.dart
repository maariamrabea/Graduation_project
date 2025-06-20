import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BottomBar.dart';
import '../Widget/arrow_back.dart';
import '../fontstyle.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String doctorImage;

  const AppointmentScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedTime = "9:30 PM";
  bool isLoading = false;
  DateTime selectedDate = DateTime(2025, 2, 16);

  final List<String> times = [
    "8:00 PM",
    "8:30 PM",
    "9:00 PM",
    "9:30 PM",
    "10:00 PM",
    "10:30 PM",
    "11:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = const Color(0xFF557C91);
    final lightGrey = Colors.black12;

    final List<int> days = _generateDays(selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDoctorCard(primaryColor),
            const SizedBox(height: 20),
            _buildAvailableTimesCard(primaryColor, lightGrey),
            const Spacer(),
            _buildBookButton(primaryColor, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Color primaryColor) {
    final List<int> days = _generateDays(selectedDate);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.doctorImage.isNotEmpty
                      ? NetworkImage(widget.doctorImage)
                      : const AssetImage('assets/images/default_doctor.png')
                  as ImageProvider,
                  radius: 30,
                  onBackgroundImageError: (_, __) {
                    print('Image load error for ${widget.doctorImage}');
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  widget.doctorName,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: _pickDate,
                ),
                Text(
                  '${_getMonthName(selectedDate.month)}, ${selectedDate.year}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDaysList(days),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysList(List<int> days) {
    final size = MediaQuery.of(context).size;
    final primaryColor = const Color(0xFF557C91);
    final lightGrey = Colors.black12;

    return SizedBox(
      height: size.height * 0.08,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          bool isSelected = selectedDate.day == day;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  day,
                );
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getDayName(
                      DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        day,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailableTimesCard(Color primaryColor, Color lightGrey) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'images/calendar.png',
                    color: Colors.black54,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Available', style: AppTextStyles.f18),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimesList(primaryColor, lightGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildTimesList(Color primaryColor, Color lightGrey) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: times.map((time) {
        bool isSelected = selectedTime == time;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTime = time;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookButton(Color primaryColor, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF557C91),
        ),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _bookAppointment,
        child: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void _bookAppointment() async {
    setState(() {
      isLoading = true;
    });

    // محاكاة عملية الحجز
    Future.delayed(const Duration(seconds: 2), () async {
      setState(() {
        isLoading = false;
      });

      // تخزين بيانات الدكتور في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('doctor_name', widget.doctorName);
      await prefs.setString('doctor_image', widget.doctorImage);
      await prefs.setString('appointment_date', selectedDate.toIso8601String());
      await prefs.setString('appointment_time', selectedTime);

      // عرض رسالة تأكيد
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/weui_done2-filled.png', height: 65),
              const SizedBox(height: 20),
              const Text(
                'Thank You!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Your appointment has been successfully created on ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year} at $selectedTime',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق نافذة الحوار
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBar()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF557C91),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<int> _generateDays(DateTime date) {
    int lastDay = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(lastDay, (i) => i + 1);
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getDayName(DateTime date) {
    const List<String> weekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];
    return weekdays[date.weekday % 7];
  }
}