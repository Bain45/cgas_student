import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTokenPage extends StatelessWidget {
  final Map<String, dynamic> request;

  const StudentTokenPage({Key? key, required this.request, required String studentName, required student}) : super(key: key);

  Future<String?> _fetchProfilePicture(String studentId) async {
    try {
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (studentDoc.exists) {
        return studentDoc.data()?['imageUrl']; // Assuming 'imageUrl' contains the profile photo URL
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
    return null;
  }

  Future<void> _updateRequestStatus(String requestId, int status) async {
    try {
      await FirebaseFirestore.instance
          .collection(request['type']) // Use the type to determine which collection (inpass or outpass)
          .doc(requestId)
          .update({'status': status});
      print('Status updated to $status for request ID: $requestId');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentInfo = request['studentInfo'];
    final requestData = request['data'];
    final studentId = requestData['studentUid'];
    final requestId = request['id']; // Get the request ID for updates

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<String?>(
        future: _fetchProfilePicture(studentId),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      snapshot.data ?? 'gs://cgas-2024.appspot.com/student_photos',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Student Name: ${studentInfo['name']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register Number: ${studentInfo['registerNumber']}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 254, 254)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Academic Year: ${studentInfo['academicYear']}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const Divider(height: 24, color: Color.fromARGB(141, 249, 249, 249)),
                Text(
                  'Request Type: ${request['type']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reason: ${requestData['reason']}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${requestData['date']}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time: ${requestData['time']}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${requestData['status']}',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle approve action
                        _updateRequestStatus(requestId, 3); // Set status to 3 for approved
                        Navigator.pop(context); // Close the details page
                      },
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle reject action
                        _updateRequestStatus(requestId, 4); // Set status to 4 for rejected
                        Navigator.pop(context); // Close the details page
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
    );
  }
}
