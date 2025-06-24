import 'package:flutter/material.dart';

import 'doctor_part/AppointmentDocScreen.dart';
import 'doctor_part/Doctorprofile.dart';
import 'doctor_part/Home_doctor.dart';

// class BottomNavBarDoctor extends StatefulWidget {
//   const BottomNavBarDoctor({super.key});
//
//   @override
//   _BottomNavBarDoctorState createState() => _BottomNavBarDoctorState();
// }
//
// class _BottomNavBarDoctorState extends State<BottomNavBarDoctor> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     DoctorHomeScreen(),
//     AppointmentDocScreen(),
//     Doctorprofile(),
//   ];
//
//   final List<String> icons = [
//     'assets/icons/home.png',
//     'assets/icons/reminder_8836228.png',
//     'assets/icons/doctor-appointment (1).png',
//   ];
//
//   final List<String> labels = ['Home', 'Appointments', 'Profile'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF567A88),
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//         elevation: 10,
//         items: List.generate(icons.length, (index) {
//           return BottomNavigationBarItem(
//             icon: ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 _currentIndex == index ? const Color(0xFF567A88) : Colors.grey,
//                 BlendMode.srcIn,
//               ),
//               child: Image.asset(icons[index], width: 24, height: 24),
//             ),
//             label: labels[index],
//           );
//         }),
//       ),
//     );
//   }
// }

class BottomNavBarDoctor extends StatefulWidget {
  const BottomNavBarDoctor({super.key});

  @override
  State<BottomNavBarDoctor> createState() => _BottomNavBarDoctorState();
}

class _BottomNavBarDoctorState extends State<BottomNavBarDoctor> {
  int _currentIndex = 0; // المؤشر الحالي للتبويب النشط

  // قائمة الـ Widgets (الصفحات) التي ستعرض لكل تبويب
  final List<Widget> _doctorPages = [
    DoctorHomeScreen(), // على سبيل المثال:
    AppointmentsScreen(),
    Doctorprofile(),

    // لغرض العرض، سنضع نصوص بسيطة
    const Center(child: Text('Doctor Home Screen Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Doctor Appointments Screen Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Doctor Profile Screen Content', style: TextStyle(fontSize: 24))),
  ];

  // قائمة مسارات الأيقونات
  final List<String> _icons = [
    'images/home.png',
    'images/img.png', // ربما تكون هذه أيقونة المواعيد أو أيقونة ذات صلة
    'images/profile.png',
  ];

  // قائمة النصوص للتبويبات
  final List<String> _labels = ['Home', 'Appointments', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // الجزء الرئيسي من الشاشة الذي يعرض الصفحة المختارة
      body: _doctorPages[_currentIndex],
      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // تحديث المؤشر عند النقر على تبويب
          });
        },
        type: BottomNavigationBarType.fixed, // يجعل الأيقونات ثابتة ولا تتحرك
        selectedItemColor: const Color(0xFF567A88), // لون العنصر المختار
        unselectedItemColor: Colors.grey, // لون العناصر غير المختارة
        backgroundColor: Colors.white,
        elevation: 10, // ظل شريط التنقل
        items: List.generate(_icons.length, (index) {
          return BottomNavigationBarItem(
            icon: ColorFiltered(
              // لتغيير لون الأيقونة حسب حالة التحديد
              colorFilter: ColorFilter.mode(
                _currentIndex == index
                    ? const Color(0xFF567A88) // إذا كان العنصر هو المختار، استخدم اللون المحدد
                    : Colors.grey, // وإلا، استخدم اللون الرمادي
                BlendMode.srcIn,
              ),
              child: Image.asset(_icons[index], width: 24, height: 24), // عرض الأيقونة
            ),
            label: _labels[index], // عرض النص الخاص بالتبويب
          );
        }),
      ),
    );
  }
}