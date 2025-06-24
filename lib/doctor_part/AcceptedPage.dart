import 'package:flutter/material.dart';

// ✅ القائمة المشتركة للحجوزات المقبولة
List<Map<String, String>> acceptedBookings = [];

class AcceptedPage extends StatefulWidget {
  const AcceptedPage({super.key});

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  void _showAddBookingDialog() {
    String name = '';
    String date = '';
    String time = '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text('Add Manual Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (val) => name = val,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
              ),
              onChanged: (val) => date = val,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Time (e.g. 10:00 AM)',
              ),
              onChanged: (val) => time = val,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF567A88),
            ),
            child: const Text('Add'),
            onPressed: () {
              if (name.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
                setState(() {
                  acceptedBookings.add({
                    'name': name,
                    'date': date,
                    'time': time,
                  });
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index) {
    String name = acceptedBookings[index]['name']!;
    String date = acceptedBookings[index]['date']!;
    String time = acceptedBookings[index]['time']!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text('Edit Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: name),
              onChanged: (val) => name = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Date'),
              controller: TextEditingController(text: date),
              onChanged: (val) => date = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Time'),
              controller: TextEditingController(text: time),
              onChanged: (val) => time = val,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF567A88),
            ),
            child: const Text('Save'),
            onPressed: () {
              setState(() {
                acceptedBookings[index] = {
                  'name': name,
                  'date': date,
                  'time': time,
                };
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      acceptedBookings.isEmpty
          ? const Center(child: Text('No accepted bookings yet'))
          : ListView.builder(
        itemCount: acceptedBookings.length,
        itemBuilder: (context, index) {
          final booking = acceptedBookings[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/user (2).png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          booking['name']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            _showEditDialog(index);
                          } else if (value == 'Delete') {
                            setState(() {
                              acceptedBookings.removeAt(index);
                            });
                          }
                        },
                        itemBuilder:
                            (context) => [
                          const PopupMenuItem(
                            value: 'Edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'Delete',
                            child: Text('Delete'),
                          ),
                          const PopupMenuItem(
                            value: 'Details',
                            child: Text('View Details'),
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
                      const SizedBox(width: 15),
                      Container(
                        width: 1,
                        height: 15,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 15),
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
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookingDialog,
        backgroundColor: const Color(0xFF567A88),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}