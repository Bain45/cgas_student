import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PastRecordsPage extends StatelessWidget {
  const PastRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').where('status', isGreaterThan: 1).snapshots(), // Assuming status > 1 is for past records
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          final pastRecords = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: pastRecords.length,
            itemBuilder: (context, index) {
              final record = pastRecords[index];
              final studentName = record['studentName'];
              final registerNumber = record['registerNumber'];
              final status = record['status'];

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(studentName),
                  subtitle: Text('Reg No: $registerNumber'),
                  trailing: Text(status == 2 ? 'Rejected' : 'Approved'), // Display status
                ),
              );
            },
          );
        },
      ),
    );
  }
}
