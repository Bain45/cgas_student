import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CombinedRequestsPage extends StatefulWidget {
  const CombinedRequestsPage({Key? key}) : super(key: key);

  @override
  _CombinedRequestsPageState createState() => _CombinedRequestsPageState();
}

class _CombinedRequestsPageState extends State<CombinedRequestsPage> {
  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    List<Map<String, dynamic>> combinedRequestsList = [];
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not logged in!");
      return combinedRequestsList;
    }

    String facultyId = user.uid;

    try {
      // Get the HOD's department ID
      final hodDoc = await FirebaseFirestore.instance
          .collection('hod')
          .doc(facultyId)
          .get();

      // Verify that the document exists
      if (hodDoc.exists) {
        String departmentId = hodDoc.data()!['departmentId'];

        // Fetch Inpass Requests for the department with status 1
        final inpassSnapshot = await FirebaseFirestore.instance
            .collection('inpass')
            .where('departmentId', isEqualTo: departmentId)
            .where('status', isEqualTo: 1)
            .get();

        for (var doc in inpassSnapshot.docs) {
          final studentId = doc.data()['studentUid'];

          final studentDoc = await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();

          if (studentDoc.exists) {
            final academicYearId = studentDoc.data()!['year'];
            final academicYearDoc = await FirebaseFirestore.instance
                .collection('academicYears')
                .doc(academicYearId)
                .get();

            combinedRequestsList.add({
              'type': 'inpass',
              'data': doc.data(),
              'studentInfo': {
                'name': studentDoc.data()!['name'],
                'registerNumber': studentDoc.data()!['regnum'],
                'academicYear': academicYearDoc.data()!['academicYear'],
              },
              'id': doc.id,
            });
          }
        }

        // Fetch Outpass Requests for the department with status 1
        final outpassSnapshot = await FirebaseFirestore.instance
            .collection('outpass')
            .where('departmentId', isEqualTo: departmentId)
            .where('status', isEqualTo: 1)
            .get();

        for (var doc in outpassSnapshot.docs) {
          final studentId = doc.data()['studentUid'];

          final studentDoc = await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();

          if (studentDoc.exists) {
            final academicYearId = studentDoc.data()!['year'];
            final academicYearDoc = await FirebaseFirestore.instance
                .collection('academicYears')
                .doc(academicYearId)
                .get();

            combinedRequestsList.add({
              'type': 'outpass',
              'data': doc.data(),
              'studentInfo': {
                'name': studentDoc.data()!['name'],
                'registerNumber': studentDoc.data()!['regnum'],
                'academicYear': academicYearDoc.data()!['academicYear'],
              },
              'id': doc.id,
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching requests: $e");
    }

    return combinedRequestsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text(
          'GatePass Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found.', style: TextStyle(color: Colors.white)));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final studentInfo = request['studentInfo'];

              return Card(
                color: const Color.fromARGB(255, 149, 218, 239),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    studentInfo['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 0, 0),
                    ),
                  ),
                  subtitle: Text(
                    'Register Number: ${studentInfo['registerNumber']}\nAcademic Year: ${studentInfo['academicYear']}',
                    style: const TextStyle(color: Color.fromARGB(137, 0, 0, 0)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailsPage(request: request),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RequestDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;

  const RequestDetailsPage({Key? key, required this.request}) : super(key: key);

  Future<String?> _fetchProfilePicture(String studentId) async {
    try {
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (studentDoc.exists) {
        return studentDoc.data()!['imageUrl'];
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
    return null;
  }

  Future<void> _updateRequestStatus(String requestId, int status) async {
    try {
      await FirebaseFirestore.instance
          .collection(request['type'])
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
    final requestId = request['id'];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text('Request Details', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        iconTheme: const IconThemeData(color: Colors.white),
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
                      snapshot.data ?? '//cgas-2024.appspot.com/student_photos',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Student Name: ${studentInfo['name']}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
    );
  }
}
