// في ملفات الـ models الخاصة بك (مثلاً lib/models/booking.dart)
import 'package:intl/intl.dart';

class Patient { // أضفت Patient model لأنه هو الذي يظهر في البطاقة
  final int id;
  final String fullName;
  final String? imageUrl; // يمكن أن يكون URL لصورة المريض
  final String? specialty; // أحياناً يكون للمريض تخصص أو مهنة، أو قد يكون null

  Patient({
    required this.id,
    required this.fullName,
    this.imageUrl,
    this.specialty,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Unknown Patient',
      imageUrl: json['image'], // تأكدي من المفتاح الصحيح للصورة في الـ JSON
      specialty: json['specialty'], // تأكدي من المفتاح الصحيح للتخصص
    );
  }
}

class Doctor { // نموذج Doctor (إذا كان الـ Booking سيرجع تفاصيله)
  final int id;
  final String fullName;
  final String? specialty;
  final String? imageUrl;

  Doctor({
    required this.id,
    required this.fullName,
    this.specialty,
    this.imageUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Unknown Doctor',
      specialty: json['specialty'],
      imageUrl: json['image'],
    );
  }
}

class Booking {
  final int id;
  final Patient patient; // المريض الذي قام بالحجز
  final Doctor doctor; // الدكتور الذي تم الحجز لديه
  final String bookingDate; // التاريخ كـ String (YYYY-MM-DD)
  final String bookingTime; // الوقت كـ String (HH:MM:SS)
  String status;

  Booking({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // تحليل بيانات المريض
    final patientData = json['patient'] ?? {};
    final patient = Patient.fromJson(patientData);

    // تحليل بيانات الدكتور
    final doctorData = json['doctor'] ?? {};
    final doctor = Doctor.fromJson(doctorData);

    return Booking(
      id: json['id'],
      patient: patient,
      doctor: doctor,
      bookingDate: json['booking_date'], // المفترض أنها سترجع كـ "YYYY-MM-DD"
      bookingTime: json['booking_time'], // المفترض أنها سترجع كـ "HH:MM:SS"
      status: json['status'] ?? 'pending',
    );
  }

  // دوال مساعدة لتنسيق التاريخ والوقت
  DateTime get parsedBookingDate {
    return DateTime.parse(bookingDate);
  }

  String get formattedBookingTime {
    try {
      // assuming bookingTime is HH:MM:SS or HH:MM
      final time = DateFormat('HH:mm:ss').parse(bookingTime);
      return DateFormat('h:mm a').format(time); // Convert to 12-hour format with AM/PM
    } catch (e) {
      print('Error parsing booking time: $e');
      return bookingTime; // Fallback to original string
    }
  }

  String get formattedBookingDate {
    try {
      final date = DateTime.parse(bookingDate);
      return DateFormat('EEEE, d MMM').format(date); // Example: Monday, 6 May
    } catch (e) {
      print('Error parsing booking date: $e');
      return bookingDate; // Fallback to original string
    }
  }
}