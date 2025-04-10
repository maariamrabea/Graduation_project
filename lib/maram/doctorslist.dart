import 'package:flutter/material.dart';

import 'doctorcard.dart';

class Doctorslist extends StatefulWidget {
  const Doctorslist({super.key});

  @override
  State<Doctorslist> createState() => _DoctorslistState();
}

class _DoctorslistState extends State<Doctorslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctors',
          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),

      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(8.0), child: _buildSearchBar()),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.vertical,

              itemBuilder: (context, index) {
                return const Doctorcard();
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSearchBar() {
    return Center(
      child: Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: const Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Search for doctor',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
