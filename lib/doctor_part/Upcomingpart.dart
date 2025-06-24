import 'package:flutter/material.dart';
import 'AcceptedPage.dart';

// ✅ قائمة الحجز القادمة (مشتركة بين التابين)
List<Map<String, String>> upcomingBookings = [
  {'name': 'Maram Mohammed', 'date': '2025-06-20', 'time': '09:00 PM'},
  {'name': 'Mariam Akram', 'date': '2025-06-22', 'time': '09:30 PM'},
  {'name': 'Fatima Ahmed', 'date': '2025-06-21', 'time': '10:00 PM'},
  {'name': 'Omar Khaled', 'date': '2025-06-20', 'time': '08:30 PM'},
  {'name': 'Ali Hassan', 'date': '2025-06-21', 'time': '10:00 AM'},
  {'name': 'Hana Mohamed', 'date': '2025-06-22', 'time': '11:00 AM'},
  {'name': 'Youssef Ali', 'date': '2025-06-23', 'time': '12:30 PM'},
  {'name': 'Amina Samir', 'date': '2025-06-20', 'time': '09:15 PM'},
  {'name': 'Laila Ahmed', 'date': '2025-06-21', 'time': '10:30 Am'},
  {'name': 'Omar Hassan', 'date': '2025-06-22', 'time': '11:45 AM'},
  {'name': 'Nour Mohamed', 'date': '2025-06-23', 'time': '01:15 PM'},
  {'name': 'Hassan Ali', 'date': '2025-06-20', 'time': '09:45 PM'},
  {'name': 'Marwa Hassan', 'date': '2025-06-21', 'time': '10:00 AM'},
  {'name': 'Ahmed Ali', 'date': '2025-06-22', 'time': '11:30 AM'},
  {'name': 'Sara Mohamed', 'date': '2025-06-23', 'time': '01:00 PM'},
];

class Upcomingpart extends StatefulWidget {
  final TabController tabController;
  const Upcomingpart({super.key, required this.tabController});

  @override
  State<Upcomingpart> createState() => _UpcomingpartState();
}

class _UpcomingpartState extends State<Upcomingpart> {
  void _showCancelDialog(int index) {
    const blue = Color(0xFF567A88);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cancel Appointment',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: blue,
                backgroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: blue,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  upcomingBookings.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking canceled successfully'),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return upcomingBookings.isEmpty
        ? const Center(child: Text('No bookings yet'))
        : ListView.builder(
      itemCount: upcomingBookings.length,
      itemBuilder: (context, index) {
        final booking = upcomingBookings[index];
        return Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/user (2).png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['name']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Dermatological examination',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF567A88),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      booking['date']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF567A88),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF567A88),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      booking['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF567A88),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF567A88),
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () => _showCancelDialog(index),
                        child: const Text('Cancel'),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFF567A88).withOpacity(0.4),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF567A88),
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          final acceptedBooking = upcomingBookings[index];

                          setState(() {
                            upcomingBookings.removeAt(index);
                            acceptedBookings.add(acceptedBooking);
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  'Appointment Accepted',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Appointment scheduled successfully for:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${acceptedBooking['date']} at ${acceptedBooking['time']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF567A88),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF567A88,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          widget.tabController.animateTo(1);
                                        },
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}