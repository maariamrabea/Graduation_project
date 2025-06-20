import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../ApiConstants.dart';
import '../dio_helper.dart';


class LastCase extends StatefulWidget {
  @override
  _LastCaseState createState() => _LastCaseState();
}

class _LastCaseState extends State<LastCase> {
  bool isLoading = true;
  Map<String, dynamic>? lastScan;

  @override
  void initState() {
    super.initState();
    _loadLastScan();
  }

  Future<void> _loadLastScan() async {
    setState(() => isLoading = true);
    try {
      final response = await DioHelper.dio.get('${ApiConstants.dio}api/scans/last/');
      if (response.statusCode == 200) {
        setState(() {
          lastScan = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          lastScan = null;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No scan found: ${response.statusCode}')));
      }
    } catch (e) {
      setState(() {
        lastScan = null;
        isLoading = false;
      });
      if (e is DioException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        print('Dio Error: ${e.response?.data}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: !isLoading && lastScan != null && lastScan!['image_url'] != null
                ? Colors.transparent
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: !isLoading && lastScan != null && lastScan!['image_url'] != null
                ? [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : lastScan != null && lastScan!['image_url'] != null
              ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanResult(
                    imageUrl: lastScan!['image_url'], // تمرير image_url
                    diseaseName: lastScan!['disease']['name'] ?? 'Unknown',
                    probability: lastScan!['probability'] is double
                        ? '${(lastScan!['probability'] * 100).toStringAsFixed(2)}%'
                        : lastScan!['probability'] ?? 'N/A',
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                lastScan!['image_url'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Image failed to load'));
                },
              ),
            ),
          )
              : Center(
            child: Image.asset(
              'images/14896150.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class ScanResult extends StatefulWidget {
  final String? imageUrl;
  final String diseaseName;
  final String probability;

  const ScanResult({
    Key? key,
    this.imageUrl,
    required this.diseaseName,
    required this.probability,
  }) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Scan Result",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.imageUrl != null
                    ? Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Image failed to load'));
                  },
                )
                    : Container(color: Colors.grey[300]),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.diseaseName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Text(
              'Probability: ${widget.probability}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}