import 'package:flutter/material.dart';

class PastRecordsPage extends StatelessWidget {
  const PastRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample past records (replace with actual data)
    List<String> pastRecords = ["Record 1", "Record 2", "Record 3"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Records'),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      ),
      body: ListView.builder(
        itemCount: pastRecords.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 6,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              tileColor: const Color.fromARGB(255, 124, 213, 249),
              title: Text(
                pastRecords[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
