import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CombinedRequestsPage extends StatefulWidget {
  const CombinedRequestsPage({Key? key}) : super(key: key);

  @override
  _CombinedRequestsPageState createState() => _CombinedRequestsPageState();
}

class _CombinedRequestsPageState extends State<CombinedRequestsPage> {
  Future<List<Map<String, dynamic>>> _fetchInpassAndOutpassData() async {
    List<Map<String, dynamic>> combinedRequestsList = [];
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not logged in!");
      return combinedRequestsList;
    }

    String facultyId = user.uid;

    try {
      // Step 1: Fetch all students under this faculty
      print("Fetching students for facultyId: $facultyId");
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('facultyId', isEqualTo: facultyId)
          .get();

      // Get a list of student UIDs
      List<String> studentUids = studentsSnapshot.docs
          .map((doc) => doc.id)
          .toList();

      // Step 2: Fetch Inpass Requests for these students
      print("Fetching inpass data for students: $studentUids");
      final inpassSnapshot = await FirebaseFirestore.instance
          .collection('inpass')
          .where('studentUid', whereIn: studentUids)
          .get();

      for (var doc in inpassSnapshot.docs) {
        final studentId = doc.data()['studentUid'];
        print("Inpass document data: ${doc.data()}");

        // Fetch student information using studentId
        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) {
          print("Student document not found for ID: $studentId");
          continue;
        }

        print("Student document data: ${studentDoc.data()}");

        // Fetch academic year using studentId
        final academicYearId = studentDoc.data()?['year'];
        final academicYearDoc = await FirebaseFirestore.instance
            .collection('academicYears')
            .doc(academicYearId)
            .get();

        combinedRequestsList.add({
          'type': 'inpass',
          'data': doc.data(),
          'studentInfo': {
            'name': studentDoc.data()?['name'] ?? 'No Name',
            'registerNumber': studentDoc.data()?['regnum'] ?? 'N/A',
            'academicYear': academicYearDoc.data()?['academicyear'] ?? 'N/A',
          },
          'id': doc.id, // Add document ID if needed for further operations
        });
      }

      // Step 3: Fetch Outpass Requests for these students
      print("Fetching outpass data for students: $studentUids");
      final outpassSnapshot = await FirebaseFirestore.instance
          .collection('outpass')
          .where('studentUid', whereIn: studentUids)
          .get();

      for (var doc in outpassSnapshot.docs) {
        final studentId = doc.data()['studentUid'];
        print("Outpass document data: ${doc.data()}");

        // Fetch student information using studentId
        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) {
          print("Student document not found for ID: $studentId");
          continue;
        }

        print("Student document data: ${studentDoc.data()}");

        // Fetch academic year using studentId
        final academicYearId = studentDoc.data()?['year'];
        final academicYearDoc = await FirebaseFirestore.instance
            .collection('academicYears')
            .doc(academicYearId)
            .get();

        combinedRequestsList.add({
          'type': 'outpass',
          'data': doc.data(),
          'studentInfo': {
            'name': studentDoc.data()?['name'] ?? 'No Name',
            'registerNumber': studentDoc.data()?['regnum'] ?? 'N/A',
            'academicYear': academicYearDoc.data()?['academicyear'] ?? 'N/A',
          },
          'id': doc.id, // Add document ID if needed for further operations
        });
      }
    } catch (e) {
      print("Error fetching requests: $e");
    }

    return combinedRequestsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchInpassAndOutpassData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Fetching data...");
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error fetching data: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("No data found");
            return const Center(child: Text('No requests found.'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final studentInfo = request['studentInfo'];
              return ListTile(
                title: Text(studentInfo['name'] ?? 'No Name'),
                subtitle: Text(
                  'Register Number: ${studentInfo['registerNumber']}\nAcademic Year: ${studentInfo['academicYear']}',
                ),
                onTap: () {
                  // Navigate to another screen to show full details of the request
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailsPage(
                        request: request,
                      ),
                    ),
                  );
                },
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
        return studentDoc.data()?['photoUrl']; // Assuming 'photoUrl' field contains the URL of the profile photo
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final studentInfo = request['studentInfo'];
    final requestData = request['data'];
    final studentId = requestData['studentUid'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: const Color(0xFF032935), // Dark blue color
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
                    backgroundImage: snapshot.hasData
                        ? NetworkImage(snapshot.data!)
                        : const AssetImage('assets/placeholder.jpg')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Student Name: ${studentInfo['name']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register Number: ${studentInfo['registerNumber']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Academic Year: ${studentInfo['academicYear']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const Divider(height: 24, color: Colors.white30),
                Text(
                  'Request Type: ${request['type']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reason: ${requestData['reason']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${requestData['status']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle approve action
                      },
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle reject action
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFF041C32), // Dark background color
    );
  }
}

