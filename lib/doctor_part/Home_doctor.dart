import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import 'AppointmentDocScreen.dart';
import 'appbardoc.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  Map<String, dynamic>? latestBooking;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchLatestPendingBooking();
  }

  Future<void> fetchLatestPendingBooking() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final response = await DioHelper.getWithAuthRequest(
        '${ApiConstants.dio}api/doctors/bookings/latest-pending/',
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          setState(() {
            latestBooking = response.data;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Invalid data format from API';
            isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'No pending bookings found';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching booking: $e';
        isLoading = false;
      });
      print('Fetch error: $e');
    }
  }

  Future<void> updateBookingStatus(String status) async {
    if (latestBooking == null || latestBooking!['id'] == null) {
      setState(() {
        errorMessage = 'No booking selected to update';
      });
      return;
    }

    try {
      final response = await DioHelper.dio.patch(
        '${ApiConstants.dio}${ApiConstants.bookingUpdate.replaceFirst('<int:pk>', latestBooking!['id'].toString())}',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        if (status == 'accepted') {
          _showSuccessDialog(
            latestBooking!['booking_date'],
            latestBooking!['booking_time'],
          );
        } else if (status == 'cancelled') {
          _showCancelDialog();
        }
        setState(() {
          latestBooking = null;
          errorMessage = 'Booking $status successfully';
        });
        await fetchLatestPendingBooking();
      } else {
        setState(() {
          errorMessage =
              'Failed to update booking status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error updating booking: $e';
      });
      print('Update error details: $e');
    }
  }

  void _showSuccessDialog(String date, String time) {
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
                Image.asset('assets/images/weui_done2-filled.png', height: 65),
                SizedBox(height: 20),
                Text(
                  'Appointment Accepted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Appointment scheduled successfully for:',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  '${_formatDate(date)}, ${_formatTime(time)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF567A88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
    );
  }

  void _showCancelDialog() {
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
                Image.asset('assets/images/cancel_icon.png', height: 65),
                SizedBox(height: 20),
                Text(
                  'Appointment Cancelled',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'The appointment has been successfully cancelled.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF567A88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMM').format(date);
    } catch (e) {
      return dateStr;
    }
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(children: [SizedBox(height: 50), Appbardoc()]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming appointments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF567A88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : latestBooking == null
                      ? Center(child: Text('No pending bookings available'))
                      : Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        latestBooking!['patient']['image_url'] !=
                                                null
                                            ? NetworkImage(
                                              latestBooking!['patient']['image_url']
                                                  as String,
                                            )
                                            : null,
                                    child:
                                        latestBooking!['patient']['image_url'] ==
                                                null
                                            ? Icon(
                                              Icons.person,
                                              color: Colors.grey[600],
                                            )
                                            : null,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          latestBooking!['patient'].containsKey(
                                                'full_name',
                                              )
                                              ? '${latestBooking!['patient']['full_name']}'
                                              : latestBooking!['patient']
                                                  .containsKey('first_name')
                                              ? '${latestBooking!['patient']['first_name'] ?? 'Unknown'} ${latestBooking!['patient']['last_name'] ?? 'Patient'}'
                                              : 'Unknown Patient',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Dermatological examination',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: 340,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Color(0x91E3EDF2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                ),

                                // width: 200,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Color(0xFF6D838E),
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                _formatDate(
                                                  latestBooking!['booking_date'] ??
                                                      '',
                                                ),
                                                style: TextStyle(
                                                  color: Color(0xFF6D838E),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 55),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Color(0xFF6D838E),
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                _formatTime(
                                                  latestBooking!['booking_time'] ??
                                                      '',
                                                ),
                                                style: TextStyle(
                                                  color: Color(0xFF6D838E),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                             // SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
