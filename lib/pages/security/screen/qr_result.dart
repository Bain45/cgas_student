import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultPage extends StatelessWidget {
  final String result;

  ResultPage({required this.result});

  Future<Map<String, dynamic>> fetchStudentData(String documentId, String action) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    String collectionName = action == "INPASS" ? "inpass" : "outpass";
    Map<String, dynamic> studentData = {};

    try {
      DocumentSnapshot inpassOrOutpassDoc = await firestore.collection(collectionName).doc(documentId).get();

      if (!inpassOrOutpassDoc.exists) {
        print("Document not found");
        return {};
      }

      String studentUid = inpassOrOutpassDoc['studentUid'];
      String reason = inpassOrOutpassDoc['reason'];
      Timestamp timestamp = inpassOrOutpassDoc['timestamp'];
      DateTime dateTime = timestamp.toDate();

      DocumentSnapshot studentDoc = await firestore.collection('students').doc(studentUid).get();
      if (!studentDoc.exists) {
        print("Student not found");
        return {};
      }

      String departmentId = studentDoc['departmentId'];
      DocumentSnapshot departmentDoc = await firestore.collection('department').doc(departmentId).get();
      
      String yearId = studentDoc['year'];
      DocumentSnapshot yearDoc = await firestore.collection('academicYears').doc(yearId).get();

      String studentName = studentDoc['name'];
      String studentPhoto = studentDoc['imageUrl'];
      String department = departmentDoc['department'];
      String year = yearDoc['academicYear'];

      studentData = {
        'studentName': studentName,
        'studentPhoto': studentPhoto,
        'department': department,
        'year': year,
        'reason': reason,
        'date': dateTime.toLocal().toString().split(' ')[0],
        'time': dateTime.toLocal().toString().split(' ')[1].split('.')[0],
        'status': inpassOrOutpassDoc['status'],
        'action': action,
      };

    } catch (e) {
      print("Error fetching data: $e");
    }

    return studentData;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = jsonDecode(result);
    String documentId = data['documentId'];
    String action = data['action'];

    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 4, 20, 44),
      appBar: AppBar(
         title: const Text('Student Details'),
        backgroundColor: const Color.fromARGB(255, 163, 234, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStudentData(documentId, action),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found.'));
          }

          final studentData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Student Details',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 4, 20, 44)),
                ),
                SizedBox(height: 20),
                Card(
                  color: const Color.fromARGB(255, 163, 234, 255),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(studentData['studentPhoto']),
                          radius: 40,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentData['studentName'],
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 4, 20, 44)),
                              ),
                              SizedBox(height: 8),
                              Text('Department: ${studentData['department']}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              Text('Year: ${studentData['year']}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Action: ${studentData['action']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 4, 20, 44))),
                        SizedBox(height: 10),
                        Text('Reason: ${studentData['reason']}', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                        SizedBox(height: 10),
                        Text('Date: ${studentData['date']}', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                        SizedBox(height: 10),
                        Text('Time: ${studentData['time']}', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                        SizedBox(height: 10),
                        Text(
                          'Status: ${studentData['status'] == 3 ? "Request Sanctioned" : "Pending"}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: studentData['status'] == 4 ? Colors.green : Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
