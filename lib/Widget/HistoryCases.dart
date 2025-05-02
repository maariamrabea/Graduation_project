import 'package:flutter/material.dart';

class HistoryCases extends StatefulWidget {
  @override
  _HistoryCasesState createState() => _HistoryCasesState();
}

class _HistoryCasesState extends State<HistoryCases> {
  bool isScanCompleted = false; // للتأكد إذا كان المسح قد تم
  String imagePath = ''; // لتخزين مسار صورة المرض بعد المسح

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity, // الكونتينر يأخذ عرض الشاشة بالكامل
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[100], // لون الخلفية عندما لا يكون هناك نتيجة
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              isScanCompleted
                  ? GestureDetector(
                    onTap: () {
                      // هنا يتم توجيه المريض لصفحة النتيجة الخاصة بالمرض
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiseaseResultPage(),
                        ),
                      );
                    },
                    child: Image.asset(imagePath), // عرض صورة المرض بعد المسح
                  )
                  : Center(
                    child: Image.asset(
                      'images/14896150.png',
                    ), // صورة الكاميرا أو أيقونة تشير للمسح
                  ),
        ),
      ),
    );
  }
}

class DiseaseResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("هنا تظهر نتيجة المرض بعد المسح")),
    );
  }
}
