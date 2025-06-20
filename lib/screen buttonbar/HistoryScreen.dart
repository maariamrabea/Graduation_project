import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';
import '../result/scan_result_details.dart';

class HistoryCases extends StatefulWidget {
  @override
  _HistoryCasesState createState() => _HistoryCasesState();
}

class _HistoryCasesState extends State<HistoryCases> {
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.dio.get('${ApiConstants.dio}api/scans/all/');
      if (response.statusCode == 200) {
        final data = response.data is List ? response.data : [];
        setState(() {
          history = data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load history: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (e is DioException) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        print('Dio Error: ${e.response?.data}'); // للتحقق من الإيرور
      }
    }
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
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : history.isEmpty
              ? Center(child: Text('No history available'))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  final disease =
                      item['disease'] != null && item['disease'] is Map
                          ? item['disease']
                          : {};
                  final imageUrl = item['image_url'] ?? '';
                  // تحويل probability لـString إذا كان double
                  final probability =
                      item['probability'] is double
                          ? '${(item['probability'] * 100).toStringAsFixed(2)}%'
                          : item['probability'] ?? 'N/A';
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image:
                              imageUrl.isNotEmpty
                                  ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: imageUrl.isEmpty ? Colors.grey[300] : null,
                        ),
                      ),
                      title: Text(
                        item['id'] != null
                            ? 'Case #${item['id']}'
                            : 'Case #Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Result: ${disease['name'] ?? 'Unknown'}',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          try {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ScanResultDetails(
                                      diseaseName: disease['name'] ?? 'Unknown',
                                      probability: probability,
                                      symptoms: disease['symptoms'] ?? 'N/A',
                                      causes: disease['causes'] ?? 'N/A',
                                      prevention:
                                          disease['prevention'] ?? 'N/A',
                                    ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error navigating: $e')),
                            );
                          }
                        },
                        child: const Text('View'),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
