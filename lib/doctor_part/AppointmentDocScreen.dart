import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/BottomNavBarDoctor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import '../registration/login.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> pendingBookings = [];
  List<dynamic> acceptedBookings = []; // هيظل موجود بس مش هيستخدم للآن
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        _handleLogout();
        return;
      }

      final pendingResponse = await DioHelper.getWithAuthRequest(
        '${ApiConstants.dio}api/doctors/bookings/pending/',
      );
      final acceptedResponse = await DioHelper.getWithAuthRequest(
        '${ApiConstants.dio}api/doctors/bookings/accepted/',
      );

      if (pendingResponse.statusCode == 200) {
        setState(() {
          pendingBookings = pendingResponse.data;
        });
      } else {
        throw Exception(
          'Pending fetch failed: ${pendingResponse.statusCode} - ${pendingResponse.data}',
        );
      }

      if (acceptedResponse.statusCode == 200) {
        setState(() {
          acceptedBookings = acceptedResponse.data;
        });
      } else {
        throw Exception(
          'Accepted fetch failed: ${acceptedResponse.statusCode} - ${acceptedResponse.data}',
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        final refreshed = await DioHelper.refreshToken();
        if (refreshed) {
          await fetchBookings();
        } else {
          _handleLogout();
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching bookings: $e';
          isLoading = false;
        });
        print('Fetch error details: $e');
      }
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    if (status == 'rejected') {
      _showConfirmationDialog(bookingId, status);
      return;
    }

    try {
      final url =
          '${ApiConstants.dio}${ApiConstants.bookingUpdate.replaceFirst('<int:pk>', bookingId)}';
      print('Updating booking at URL: $url with status: $status');

      final response = await DioHelper.patchWithAuthRequest(
        url,
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('Response data: $data');

        setState(() async {
          final booking = pendingBookings.firstWhere(
            (b) => b['id'].toString() == bookingId,
            orElse: () => null,
          );
          if (booking != null) {
            pendingBookings.removeWhere((b) => b['id'].toString() == bookingId);

            if (status == 'accepted') {
              // إزالة الحجز من Upcoming بس، ما يضافش لـ acceptedBookings
              _showSuccessDialog(
                booking['booking_date'],
                booking['booking_time'],
              );
              // تحديث SharedPreferences (لو عايزة تظهر في HomeScreen)
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                'doctorName',
                booking['doctor']['full_name'] ?? 'Unknown Doctor',
              );
              await prefs.setString(
                'doctorImage',
                booking['doctor']['profile_picture_url'] ?? '',
              );
              await prefs.setString(
                'appointmentDate',
                '${_formatDate(booking['booking_date'])} ${_formatTime(booking['booking_time'])}',
              );
              await prefs.setBool('hasAppointment', true);
              // العودة لـ HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBarDoctor()),
              );
            } else if (status == 'rejected') {
              _showRejectDialog();
            }
          }
        });
      } else {
        setState(() {
          errorMessage =
              'Failed with status: ${response.statusCode} - ${response.data}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error updating booking: $e';
      });
      print('Update error details: $e');
    }
  }

  void _showConfirmationDialog(String bookingId, String status) {
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
                Text(
                  'Confirm Rejection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Are you sure you want to reject this appointment?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleRejectStatus(bookingId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF567A88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Yes', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _handleRejectStatus(String bookingId) async {
    final url =
        '${ApiConstants.dio}${ApiConstants.bookingUpdate.replaceFirst('<int:pk>', bookingId)}';

    try {
      final response = await DioHelper.patchWithAuthRequest(
        url,
        data: {'status': 'rejected'},
      );

      if (response.statusCode == 200) {
        setState(() {
          pendingBookings.removeWhere((b) => b['id'].toString() == bookingId);
        });
        _showRejectDialog();
      } else {
        setState(() {
          errorMessage = 'Failed to reject: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error rejecting: $e';
      });
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

  void _showRejectDialog() {
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
                SizedBox(height: 20),
                Text(
                  'Appointment Rejected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'The appointment has been successfully rejected.',
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

  void _handleLogout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF567A88),
        elevation: 0,
        title: Text(
          'Appointments',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // search action here
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 2.5,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [Tab(text: 'Upcoming'), Tab(text: 'Accepted')],
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: pendingBookings.length,
                    itemBuilder: (context, index) {
                      final booking = pendingBookings[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(bottom: 16),
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
                                        booking['patient']['profile_picture_url'] !=
                                                null
                                            ? NetworkImage(
                                              booking['patient']['profile_picture_url'],
                                            )
                                            : const AssetImage(
                                                  'assets/default_user.png',
                                                )
                                                as ImageProvider,
                                    onBackgroundImageError: (_, __) {
                                      print(
                                        'Image load error for ${booking['patient']['profile_picture_url']}',
                                      );
                                    },
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${booking['patient']['full_name']}',
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _formatDate(booking['booking_date']),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _formatTime(booking['booking_time']),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        onTap:
                                            () => updateBookingStatus(
                                              booking['id'].toString(),
                                              'rejected',
                                            ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.grey[400],
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        onTap:
                                            () => updateBookingStatus(
                                              booking['id'].toString(),
                                              'accepted',
                                            ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(
                                              color: Color(0xFF567A88),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: acceptedBookings.length,
                    itemBuilder: (context, index) {
                      final booking = acceptedBookings[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(bottom: 16),
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
                                        booking['patient']['profile_picture_url'] !=
                                                null
                                            ? NetworkImage(
                                              booking['patient']['profile_picture_url'],
                                            )
                                            : const AssetImage(
                                                  'assets/default_user.png',
                                                )
                                                as ImageProvider,
                                    onBackgroundImageError: (_, __) {
                                      print(
                                        'Image load error for ${booking['patient']['profile_picture_url']}',
                                      );
                                    },
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${booking['patient']['full_name']}',
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _formatDate(booking['booking_date']),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _formatTime(booking['booking_time']),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }
}
