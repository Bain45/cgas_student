import 'package:cgas_official/pages/faculty/screen/student_add.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentAddPage(),));
          }, icon: Icon(Icons.add_reaction_outlined))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching students.'));
          }

          final students = snapshot.data!.docs;

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
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(student['imageUrl']),
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                      ),
                      title: Text(student['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register Number: ${student['regnum']}'),
                          Text('Email: ${student['email']}'),
                          Text('Contact: ${student['contact']}'),
                          Text('Gender: ${student['gender']}'),
                          Text('DOB: ${student['dob']}'),
                          Text('Academic Year: $academicYear'), // Display the academic year
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
