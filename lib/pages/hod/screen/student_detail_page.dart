import 'package:flutter/material.dart';

class StudentDetailsPage extends StatelessWidget {
  final String studentName;
  final String studentUid;
  final String reason;
  final String date;
  final String requestType;

  const StudentDetailsPage({
    Key? key,
    required this.studentName,
    required this.studentUid,
    required this.reason,
    required this.date,
    required this.requestType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Name: $studentName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Student UID: $studentUid',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Request Type: ${requestType == 'inpass' ? 'Inpass' : 'Outpass'}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Reason: $reason',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
