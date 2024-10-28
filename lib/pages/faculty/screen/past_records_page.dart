import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastRecordsPage extends StatefulWidget {
  const PastRecordsPage({Key? key}) : super(key: key);

  @override
  _PastRecordsPageState createState() => _PastRecordsPageState();
}

class _PastRecordsPageState extends State<PastRecordsPage> {
  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    List<Map<String, dynamic>> requests = [];
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not logged in!");
      return requests;
    }

    String facultyId = user.uid;

    try {
      // Fetch all students under this faculty
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('facultyId', isEqualTo: facultyId)
          .get();

      List<String> studentUids = studentsSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch approved Inpass Requests for these students
      final inpassApprovedSnapshot = await FirebaseFirestore.instance
          .collection('inpass')
          .where('studentUid', whereIn: studentUids)
          .where('status', isEqualTo: 1) // Status 1 for approved
          .get();

      for (var doc in inpassApprovedSnapshot.docs) {
        final studentId = doc.data()['studentUid'];

        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) continue;

        final academicYearId = studentDoc.data()?['year'];
        final academicYearDoc = await FirebaseFirestore.instance
            .collection('academicYears')
            .doc(academicYearId)
            .get();

        requests.add({
          'type': 'inpass',
          'data': doc.data(),
          'studentInfo': {
            'name': studentDoc.data()?['name'] ?? 'No Name',
            'registerNumber': studentDoc.data()?['regnum'] ?? 'N/A',
            'academicYear': academicYearDoc.data()?['academicyear'] ?? 'N/A',
          },
          'id': doc.id,
          'status': 'Approved',
        });
      }

      // Fetch rejected Inpass Requests for these students
      final inpassRejectedSnapshot = await FirebaseFirestore.instance
          .collection('inpass')
          .where('studentUid', whereIn: studentUids)
          .where('status', isEqualTo: 2) // Status 2 for rejected
          .get();

      for (var doc in inpassRejectedSnapshot.docs) {
        final studentId = doc.data()['studentUid'];

        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) continue;

        final academicYearId = studentDoc.data()?['year'];
        final academicYearDoc = await FirebaseFirestore.instance
            .collection('academicYears')
            .doc(academicYearId)
            .get();

        requests.add({
          'type': 'inpass',
          'data': doc.data(),
          'studentInfo': {
            'name': studentDoc.data()?['name'] ?? 'No Name',
            'registerNumber': studentDoc.data()?['regnum'] ?? 'N/A',
            'academicYear': academicYearDoc.data()?['academicyear'] ?? 'N/A',
          },
          'id': doc.id,
          'status': 'Rejected',
        });
      }

      // Fetch approved Outpass Requests for these students
      final outpassApprovedSnapshot = await FirebaseFirestore.instance
          .collection('outpass')
          .where('studentUid', whereIn: studentUids)
          .where('status', isEqualTo: 1) // Status 1 for approved
          .get();

      for (var doc in outpassApprovedSnapshot.docs) {
        final studentId = doc.data()['studentUid'];

        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) continue;

        final academicYearId = studentDoc.data()?['year'];
        final academicYearDoc = await FirebaseFirestore.instance
            .collection('academicYears')
            .doc(academicYearId)
            .get();

        requests.add({
          'type': 'outpass',
          'data': doc.data(),
          'studentInfo': {
            'name': studentDoc.data()?['name'] ?? 'No Name',
            'registerNumber': studentDoc.data()?['regnum'] ?? 'N/A',
            'academicYear': academicYearDoc.data()?['academicyear'] ?? 'N/A',
          },
          'id': doc.id,
          'status': 'Approved',
        });
      }

      // Fetch rejected Outpass Requests for these students
      final outpassRejectedSnapshot = await FirebaseFirestore.instance
          .collection('outpass')
          .where('studentUid', whereIn: studentUids)
          .where('status', isEqualTo: 2) // Status 2 for rejected
          .get();

      for (var doc in outpassRejectedSnapshot.docs) {
        final studentId = doc.data()['studentUid'];

        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) continue;

        final academicYearId = studentDoc.data()?['year'];
        final academicYearDoc = await FirebaseFirestore.instance
            .collection('academicYears')
            .doc(academicYearId)
            .get();

        requests.add({
          'type': 'outpass',
          'data': doc.data(),
          'studentInfo': {
            'name': studentDoc.data()?['name'] ?? 'No Name',
            'registerNumber': studentDoc.data()?['regnum'] ?? 'N/A',
            'academicYear': academicYearDoc.data()?['academicyear'] ?? 'N/A',
          },
          'id': doc.id,
          'status': 'Rejected',
        });
      }
    } catch (e) {
      print("Error fetching requests: $e");
    }

    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Records', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found.'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestData = request['data'];
              final studentInfo = request['studentInfo'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student Name: ${studentInfo['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Register Number: ${studentInfo['registerNumber']}', style: const TextStyle(fontSize: 16)),
                      Text('Academic Year: ${studentInfo['academicYear']}', style: const TextStyle(fontSize: 16)),
                      Text('Request Type: ${request['type']}', style: const TextStyle(fontSize: 16)),
                      Text('Reason: ${requestData['reason']}', style: const TextStyle(fontSize: 16)),
                      Text('Date: ${requestData['date']}', style: const TextStyle(fontSize: 16)),
                      Text('Time: ${requestData['time']}', style: const TextStyle(fontSize: 16)),
                      const Divider(height: 20),
                      Text('Status: ${request['status']}', style: TextStyle(fontSize: 16, color: request['status'] == 'Rejected' ? Colors.red : Colors.green)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 1, 14, 38),
    );
  }
}
