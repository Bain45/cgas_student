import 'package:cgas_official/pages/faculty/screen/past_records_page.dart';
import 'package:cgas_official/pages/faculty/screen/student_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'student_token.dart';
import 'faculty_profile_page.dart';

class FacultyHomePage extends StatefulWidget {
  const FacultyHomePage({super.key});

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  int _currentIndex = 0;
  String name = 'Loading...';
  String image = '';

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }
    final userId = user.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot hodDoc = await firestore.collection('hod').doc(userId).get();

      if (hodDoc.exists) {
        final data = hodDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            name = data['name'] ?? "No Name Available";
            image = data['imageUrl'] ?? "";
          });
        }
      } else {
        print("No document found for this user.");
      }
    } catch (e) {
      print("Error Fetching Data: $e");
    }
  }

  // Sample data for students
  List<Map<String, String>> students = [
    {"name": "John Doe", "id": "ICE23MCA-2001"},
  ];

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

  // Method to build the profile header
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
                      style: TextStyle(
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
              icon: const Icon(Icons.logout,
                  size: 25, color: Color.fromARGB(255, 8, 14, 85)),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Logout confirmation dialog method
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
        return _studentApprovalList();
      case 1:
        return const PastRecordsPage(); // Use the new page
      case 2:
        return StudentaddPage();
      default:
        return Text('Error');
    }
  }

  Widget _studentApprovalList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 16.0),
          child: const Text(
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
                    "Reg No: ${students[index]["id"]}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 28, 46, 99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentToken(
                            studentName: students[index]["name"]!,
                            studentId: students[index]["id"]!,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
