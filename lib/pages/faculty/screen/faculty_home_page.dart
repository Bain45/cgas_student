import 'package:cgas_official/pages/faculty/screen/past_records_page.dart';
import 'package:cgas_official/pages/faculty/screen/request_list.dart';
import 'package:cgas_official/pages/faculty/screen/student_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'student_token.dart';
import 'faculty_profile_page.dart';

class FacultyHomePage extends StatefulWidget {
  const FacultyHomePage({super.key});

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  int _currentIndex = 0;
  String name = 'Loading...';
  String image = ''; // For faculty image
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, String>> students = []; 
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;

    try {
      DocumentSnapshot facultyDoc = await firestore.collection('faculty').doc(userId).get();

      if (facultyDoc.exists) {
        final data = facultyDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            name = data['name'] ?? "No Name Available";
            image = data['imageUrl'] ?? ""; // Get the image URL
          });
        }
      }

      await fetchStudents(userId);
    } catch (e) {
      print("Error Fetching Data: $e");
    }
  }

  Future<void> fetchStudents(String facultyId) async {
    List<Map<String, String>> studentList = [];
    
    QuerySnapshot studsnapshot = await firestore.collection('students')
        .where('facultyId', isEqualTo: facultyId)
        .get();

    for (var doc in studsnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      studentList.add({
        "name": data['studentName'] ?? "No Name",
        "id": data['studentUid'] ?? "No ID",
      });
    }

    // Get students from inpass and outpass collections
    for (var collection in ['inpass', 'outpass']) {
      QuerySnapshot snapshot = await firestore.collection(collection)
          .where('facultyId', isEqualTo: facultyId)
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        studentList.add({
          "name": data['studentName'] ?? "No Name",
          "id": data['studentUid'] ?? "No ID",
        });
      }
    }

    setState(() {
      students = studentList;
    });
  }

  Future<void> fetchPass(String studId) async {
    try {
      for (var collection in ['inpass', 'outpass']) {
        QuerySnapshot snapshot = await firestore.collection(collection)
            .where('studentUid', isEqualTo: studId)
            .get();

        for (var doc in snapshot.docs) {
          // ignore: unused_local_variable
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Process data as needed
        }
      }
    } catch (e) {
      print("Error Fetching Pass Data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 3, 18, 40),
                    Color.fromARGB(255, 6, 24, 45),
                  ],
                ),
              ),
              child: _screenItem(_currentIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        selectedItemColor: const Color.fromARGB(255, 124, 213, 249),
        unselectedItemColor: Colors.white70,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approval List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Past Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color.fromARGB(255, 3, 21, 41),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 13),
              CircleAvatar(
                radius: 30, // Adjust the size as needed
                backgroundImage: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage('assets/images/default_profile.png'), // Default image if none found
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FacultyProfilePage(),
                        ),
                      );
                    },
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'Faculty',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 149, 218, 239),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, size: 25, color: Color.fromARGB(255, 8, 14, 85)),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Do you really want to logout?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _screenItem(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return CombinedRequestsPage(); // Replace with your actual page
      case 1:
        return const PastRecordsPage(); // Replace with your actual page
      case 2:
        return const StudentListPage(facultyId: 'facultyId',); // Replace with your actual page
      default:
        return const Center(child: Text('Error'));
    }
  }

  Widget _studentApprovalList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, left: 16.0),
          child: Text(
            'Approval List',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            shrinkWrap: true,
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
                  tileColor: const Color.fromARGB(255, 149, 218, 239),
                  title: Text(
                    students[index]["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    "Reg No: ${students[index]["id"]!}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Handle student approval
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
