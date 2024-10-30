import 'package:cgas_official/pages/faculty/screen/student_add.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentListPage extends StatelessWidget {
  final String facultyId; // Field to hold the facultyId

  const StudentListPage({super.key, required this.facultyId}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        title: const Text(
          'Student List',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentAddPage(facultyId: facultyId), // Pass facultyId to StudentAddPage
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .where('facultyId', isEqualTo: facultyId) // Filter students by facultyId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching students.'));
          }

          final students = snapshot.data?.docs ?? [];

          if (students.isEmpty) {
            return const Center(child: Text('No students added.'));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              // Fetch the academic year based on the academicYearId
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('academicYears')
                    .doc(student['year']) // Assuming 'year' is the field name
                    .get(),
                builder: (context, yearSnapshot) {
                  if (yearSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading academic year...'),
                    );
                  }

                  if (yearSnapshot.hasError) {
                    return const ListTile(
                      title: Text('Error fetching academic year.'),
                    );
                  }

                  String academicYear = '';
                  if (yearSnapshot.hasData && yearSnapshot.data!.exists) {
                    academicYear = yearSnapshot.data!['academicYear'];
                  }

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 124, 213, 249), // Set row color here
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(student['imageUrl']),
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                      ),
                      title: Text(
                        student['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 2, 2, 2), // Change text color for visibility
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Register Number: ${student['regnum']}',
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Email: ${student['email']}',
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Contact: ${student['contact']}',
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Gender: ${student['gender']}',
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'DOB: ${student['dob']}',
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Academic Year: $academicYear',
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Display the academic year
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Color.fromARGB(255, 3, 21, 41)), // Change icon color to white
                        onPressed: () async {
                          // Confirm before deletion
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this student?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmDelete == true) {
                            // Delete the student from Firestore
                            await FirebaseFirestore.instance
                                .collection('students')
                                .doc(student.id) // Use the document ID
                                .delete();

                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Student deleted successfully!')),
                            );
                          }
                        },
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
