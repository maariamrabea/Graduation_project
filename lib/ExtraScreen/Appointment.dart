import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتحويل الوقت
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiConstants.dart';
import '../BottomBar.dart';
import '../dio_helper.dart';
import '../registration/login.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String doctorImage;
  final int doctorId;

  const AppointmentScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.doctorId,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedTime = "9:30 PM";
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  String? errorMessage;

  final List<String> times = [
    "8:00 PM",
    "8:30 PM",
    "9:00 PM",
    "9:30 PM",
    "10:00 PM",
    "10:30 PM",
    "11:00 PM",
  ];

  String convertTo24Hour(String time12h) {
    final time = DateFormat('h:mm a').parse(time12h);
    return DateFormat('HH:mm').format(time);
  }

  bool _isTimeInFuture(String time12h) {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(convertTo24Hour(time12h).split(':')[0]),
      int.parse(convertTo24Hour(time12h).split(':')[1]),
    );
    return selectedDateTime.isAfter(now) ||
        selectedDateTime.isAtSameMomentAs(now);
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            _buildAvailableTimesCard(primaryColor, lightGrey),
            const SizedBox(height: 40),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      widget.doctorImage.isNotEmpty
                          ? NetworkImage(widget.doctorImage)
                          : const AssetImage('assets/images/default_doctor.png')
                              as ImageProvider,
                  radius: 30,
                  onBackgroundImageError: (_, __) {
                    print('Image load error for ${widget.doctorImage}');
                  },
                ),
                const SizedBox(width: 16),
                Text(widget.doctorName, style: const TextStyle(fontSize: 18)),
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
                errorMessage = null; // إزالة الرسالة عند تغيير التاريخ
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
                      DateTime(selectedDate.year, selectedDate.month, day),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                const Text('Available', style: TextStyle(fontSize: 18)),
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
      children:
          times.map((time) {
            bool isSelected = selectedTime == time;
            bool isDisabled = !_isTimeInFuture(time);
            return GestureDetector(
              onTap:
                  isDisabled
                      ? null
                      : () {
                        setState(() {
                          selectedTime = time;
                          errorMessage =
                              null; // إزالة الرسالة عند اختيار وقت جديد
                        });
                      },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? primaryColor
                          : isDisabled
                          ? Colors.grey[300]
                          : lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color:
                        isSelected
                            ? Colors.white
                            : isDisabled
                            ? Colors.grey[600]
                            : Colors.black87,
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
      child:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF557C91)),
              )
              : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (!_isTimeInFuture(selectedTime)) {
                    setState(() {
                      errorMessage = 'Please select a future time.';
                    });
                    return;
                  }
                  _bookAppointment();
                },
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
    );
  }

  Future<void> _bookAppointment() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception('User not authenticated. Please log in.');
      }

      final doctorId = widget.doctorId;
      print('Doctor ID: $doctorId');

      final patientId = prefs.getString('user_id');
      if (patientId == null) {
        throw Exception(
          'Patient ID not found. Ensure user_id is saved after login.',
        );
      }
      print('Patient ID: $patientId');

      final bookingTime24h = convertTo24Hour(selectedTime);

      final bookingData = {
        'patient_id': patientId,
        'doctor_id': doctorId,
        'booking_date': selectedDate.toIso8601String().split('T')[0],
        'booking_time': bookingTime24h,
      };

      print('Booking data: $bookingData');

      final response = await DioHelper.dio.post(
        '${ApiConstants.dio}api/doctors/bookings/create/',
        data: bookingData,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 201) {
        setState(() {
          isLoading = false;
        });

        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.all(20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/weui_done2-filled.png',
                      height: 65,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Appointment Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your appointment is confirmed on ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year} at $selectedTime with Dr. ${widget.doctorName}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomBar()),
                      );
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to book: ${response.data['error'] ?? 'Unknown error'}';
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage!)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Session expired. Please log in again.'),
              action: SnackBarAction(
                label: 'Login',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
          );
        } else if (e.response?.statusCode == 403) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Only patients can create bookings.')),
          );
        } else if (e.response?.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server error: Endpoint not found. Check backend.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message ?? e.toString()}')),
          );
          print('Dio Error: ${e.response?.data ?? e.toString()}');
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
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
        errorMessage = null; // إزالة الرسالة عند اختيار تاريخ جديد
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

//
// class AppointmentScreen extends StatefulWidget {
//   final String doctorName;
//   final String doctorImage;
//   final int doctorId;
//
//   const AppointmentScreen({
//     super.key,
//     required this.doctorName,
//     required this.doctorImage,
//     required this.doctorId,
//   });
//
//   @override
//   State<AppointmentScreen> createState() => _AppointmentScreenState();
// }
//
// class _AppointmentScreenState extends State<AppointmentScreen> {
//   String selectedTime = "9:30 PM"; // يمكن جعلها null في البداية لعدم تحديد وقت افتراضي
//   bool isLoading = false;
//   DateTime selectedDate = DateTime.now();
//
//   final List<String> times = [
//     "8:00 PM",
//     "8:30 PM",
//     "9:00 PM",
//     "9:30 PM",
//     "10:00 PM",
//     "10:30 PM",
//     "11:00 PM",
//   ];
//
//   // دالة تحويل من 12 ساعة لـ 24 ساعة
//   String convertTo24Hour(String time12h) {
//     try {
//       final time = DateFormat('h:mm a').parse(time12h);
//       return DateFormat('HH:mm:ss').format(time); // أضفت :ss ليتوافق مع Django TimeField
//     } catch (e) {
//       print('Error converting time: $e');
//       return '00:00:00'; // قيمة افتراضية للتعامل مع الأخطاء
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = const Color(0xFF557C91);
//     final lightGrey = Colors.black12;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton( // استخدمت IconButton بدلاً من CustomIconButton لضمان عملها بدون استيراد خاص
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Appointment',
//           style: TextStyle(fontWeight: FontWeight.normal),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildDoctorCard(primaryColor),
//             const SizedBox(height: 20),
//             _buildAvailableTimesCard(primaryColor, lightGrey),
//             const SizedBox(height: 40),
//             _buildBookButton(primaryColor, isLoading),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDoctorCard(Color primaryColor) {
//     final List<int> days = _generateDays(selectedDate);
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: widget.doctorImage.isNotEmpty
//                       ? NetworkImage(widget.doctorImage)
//                       : const AssetImage('assets/images/default_doctor.png')
//                   as ImageProvider,
//                   radius: 30,
//                   onBackgroundImageError: (_, __) {
//                     print('Image load error for ${widget.doctorImage}');
//                   },
//                 ),
//                 const SizedBox(width: 16),
//                 Text(widget.doctorName, style: const TextStyle(fontSize: 18)),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios, size: 16),
//                   onPressed: () {
//                     // الانتقال للشهر السابق
//                     setState(() {
//                       selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
//                       // التأكد من أن اليوم الحالي لا يتجاوز عدد الأيام في الشهر الجديد
//                       if (selectedDate.day > DateTime(selectedDate.year, selectedDate.month + 1, 0).day) {
//                         selectedDate = DateTime(selectedDate.year, selectedDate.month, DateTime(selectedDate.year, selectedDate.month + 1, 0).day);
//                       }
//                     });
//                   },
//                 ),
//                 Text(
//                   '${_getMonthName(selectedDate.month)}, ${selectedDate.year}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onPressed: () {
//                     // الانتقال للشهر التالي
//                     setState(() {
//                       selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
//                       // التأكد من أن اليوم الحالي لا يتجاوز عدد الأيام في الشهر الجديد
//                       if (selectedDate.day > DateTime(selectedDate.year, selectedDate.month + 1, 0).day) {
//                         selectedDate = DateTime(selectedDate.year, selectedDate.month, DateTime(selectedDate.year, selectedDate.month + 1, 0).day);
//                       }
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildDaysList(days),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDaysList(List<int> days) {
//     final size = MediaQuery.of(context).size;
//     final primaryColor = const Color(0xFF557C91);
//     final lightGrey = Colors.black12;
//
//     return SizedBox(
//       height: size.height * 0.08,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: days.length,
//         itemBuilder: (context, index) {
//           final day = days[index];
//           // تأكد أننا لا نختار تاريخًا سابقًا لليوم الحالي
//           bool isPastDate = DateTime(selectedDate.year, selectedDate.month, day).isBefore(DateTime.now().subtract(const Duration(days: 1)));
//           bool isSelected = selectedDate.day == day;
//
//           return GestureDetector(
//             onTap: isPastDate ? null : () { // تعطيل النقر إذا كان التاريخ قديمًا
//               setState(() {
//                 selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
//               });
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               width: 60,
//               margin: const EdgeInsets.symmetric(horizontal: 6),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? primaryColor
//                     : (isPastDate ? Colors.grey[300] : lightGrey), // لون رمادي للتاريخ القديم
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '$day',
//                     style: TextStyle(
//                       color: isSelected
//                           ? Colors.white
//                           : (isPastDate ? Colors.grey[600] : Colors.black87),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     _getDayName(
//                       DateTime(selectedDate.year, selectedDate.month, day),
//                     ),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isSelected
//                           ? Colors.white
//                           : (isPastDate ? Colors.grey[500] : Colors.black54),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildAvailableTimesCard(Color primaryColor, Color lightGrey) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 15,
//                   backgroundColor: Colors.transparent,
//                   child: Image.asset(
//                     'assets/images/calendar.png', // تأكد من المسار الصحيح للصورة
//                     color: Colors.black54,
//                     colorBlendMode: BlendMode.srcIn,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text('Available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // استخدمت Textstyle مباشر هنا
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildTimesList(primaryColor, lightGrey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimesList(Color primaryColor, Color lightGrey) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: times.map((time) {
//         bool isSelected = selectedTime == time;
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedTime = time;
//             });
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 12,
//             ),
//             decoration: BoxDecoration(
//               color: isSelected ? primaryColor : lightGrey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               time,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.black87,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildBookButton(Color primaryColor, bool isLoading) {
//     return SizedBox(
//       width: double.infinity,
//       child: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(color: Color(0xFF557C91)),
//       )
//           : ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: _bookAppointment,
//         child: const Text(
//           'Book Appointment',
//           style: TextStyle(fontSize: 18, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _bookAppointment() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final accessToken = prefs.getString('access_token');
//       if (accessToken == null) {
//         throw Exception('User not authenticated. Please log in.');
//       }
//
//       final doctorId = widget.doctorId;
//       print('Doctor ID for booking: $doctorId');
//
//       final patientId = prefs.getString('user_id');
//       if (patientId == null) {
//         throw Exception(
//           'Patient ID not found. Ensure user_id is saved after login.',
//         );
//       }
//       print('Patient ID for booking: $patientId');
//
//       final bookingTime24h = convertTo24Hour(selectedTime);
//
//       final bookingData = {
//         'patient_id': int.parse(patientId), // تأكد أن ID هو int
//         'doctor_id': doctorId,
//         'booking_date': selectedDate.toIso8601String().split('T')[0], // YYYY-MM-DD
//         'booking_time': bookingTime24h, // HH:MM:SS
//       };
//
//       print('Booking data prepared: $bookingData');
//
//       // استخدام DioHelper.postWithAuthRequest
//       final response = await DioHelper.postWithAuthRequest(
//         ApiConstants.bookingUpdate, // استخدام المسار الصحيح
//         data: bookingData,
//       );
//
//       if (response.statusCode == 201) {
//         setState(() {
//           isLoading = false;
//         });
//
//         // عرض رسالة تأكيد
//         await showDialog( // استخدام await هنا لانتظار إغلاق الـ dialog
//           context: context,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             contentPadding: const EdgeInsets.all(20),
//             content: Column(
//               mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
//               children: [
//                 Image.asset('assets/images/weui_done2-filled.png', height: 65), // تأكد من المسار الصحيح
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Appointment Confirmed!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Your appointment is confirmed on ${_getDayName(selectedDate)}, ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year} at $selectedTime.',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context); // إغلاق الـ dialog
//                   // بعد تأكيد الحجز والعودة للشاشة الرئيسية للمريض،
//                   // يمكننا استخدام `pop` والتحقق من النتيجة في الشاشة السابقة
//                   // أو ببساطة توجيه لـ BottomBar
//                   Navigator.pushAndRemoveUntil( // للذهاب للشاشة الرئيسية للمريض وإزالة جميع الـ routes السابقة
//                     context,
//                     MaterialPageRoute(builder: (context) => BottomBar()), // تأكد من أن BottomBar هي شاشة المريض الرئيسية
//                         (route) => false,
//                   );
//                 },
//                 child: const Text(
//                   'OK',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         );
//       } else {
//         // رسالة خطأ من الـ backend
//         setState(() {
//           isLoading = false;
//         });
//         String errorMessage = 'Failed to book appointment.';
//         if (response.data != null && response.data is Map && response.data.containsKey('error')) {
//           errorMessage = response.data['error'];
//         } else if (response.data != null) {
//           errorMessage = response.data.toString();
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//         print('Server response error: ${response.statusCode} - ${response.data}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       if (e is DioException) {
//         String errorMessage = 'Error: ${e.message ?? 'Unknown error'}';
//         if (e.response != null) {
//           // دمج رسائل الخطأ بشكل صحيح (حل مشكلة String? concatenation)
//           errorMessage = (errorMessage) + '\nResponse: ${e.response?.data}';
//
//           if (e.response?.statusCode == 401) {
//             errorMessage = 'Session expired. Please log in again.';
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(errorMessage),
//                 action: SnackBarAction(
//                   label: 'Login',
//                   onPressed: () {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => Login()), // تأكد من اسم شاشة Login
//                           (route) => false,
//                     );
//                   },
//                 ),
//               ),
//             );
//             return; // لمنع ظهور SnackBar إضافي
//           } else if (e.response?.statusCode == 403) {
//             errorMessage = 'Permission denied: Only patients can create bookings.';
//           } else if (e.response?.statusCode == 404) {
//             errorMessage = 'Server error: Booking endpoint not found. Check backend.';
//           } else if (e.response?.statusCode == 400 && e.response?.data is Map) {
//             // معالجة أخطاء الـ validation من الـ backend (مثلاً 'booking_time': ['Booking must be in the future.'])
//             final errors = e.response!.data as Map;
//             if (errors.containsKey('booking_time')) {
//               errorMessage = 'Booking error: ${errors['booking_time'][0]}';
//             } else {
//               errorMessage = 'Invalid data provided: ${errors.values.first}';
//             }
//           }
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
//         );
//         print('Dio Error: $e');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An unexpected error occurred: $e'), backgroundColor: Colors.red),
//         );
//         print('Unexpected Error: $e');
//       }
//     }
//   }
//
//   // الدوال المساعدة الأخرى تبقى كما هي
//   List<int> _generateDays(DateTime date) {
//     int lastDay = DateTime(date.year, date.month + 1, 0).day;
//     // ابدأ من اليوم الحالي إذا كان الشهر هو الشهر الحالي
//     int startDay = (date.year == DateTime.now().year && date.month == DateTime.now().month)
//         ? DateTime.now().day
//         : 1;
//     return List.generate(lastDay - startDay + 1, (i) => startDay + i);
//   }
//
//   String _getMonthName(int month) {
//     const List<String> months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return months[month - 1];
//   }
//
//   String _getDayName(DateTime date) {
//     const List<String> weekdays = [
//       'Mon', // الاثنين
//       'Tue', // الثلاثاء
//       'Wed', // الأربعاء
//       'Thu', // الخميس
//       'Fri', // الجمعة
//       'Sat', // السبت
//       'Sun', // الأحد
//     ];
//     // weekday property returns 1 for Monday, 7 for Sunday.
//     // Adjust index to match 0-indexed list (0 for Mon, 6 for Sun)
//     return weekdays[date.weekday - 1];
//   }
// }
