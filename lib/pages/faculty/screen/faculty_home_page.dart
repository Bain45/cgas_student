import 'package:flutter/material.dart';
import 'student_token.dart';  // Import the student_token page
import 'faculty_profile_page.dart';  // Import the faculty_profile_page

class FacultyHomePage extends StatefulWidget {
  const FacultyHomePage({super.key});

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  int _currentIndex = 0;

  // Sample data for students (only John Doe for this example)
  List<Map<String, String>> students = [
    {"name": "John Doe", "id": "ICE23MCA-2001"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileHeader(),  // Profile header container
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 5, 54, 127),
                    Color.fromARGB(255, 2, 37, 77),
                  ],
                ),
              ),
              child: _currentIndex == 0 ? _studentApprovalList() : _pastRecords(),
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
        backgroundColor: const Color.fromARGB(255, 2, 37, 77),
        selectedItemColor: const Color.fromARGB(255, 111, 214, 255),
        unselectedItemColor: const Color.fromARGB(255, 244, 244, 244),
        selectedFontSize: 15,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approval List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Past Records',
          ),
        ],
      ),
    );
  }

  // Method to build the profile header
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(35.66),
      color: const Color.fromARGB(255, 5, 54, 127),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/images/profilephoto.jpg'),
              ),
              const SizedBox(width: 10.0),
              // Profile details
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Name button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FacultyProfilePage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Farisa Mol',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Faculty text
                  const Text(
                    'Faculty',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 149, 218, 239),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // The logout confirmation dialog method
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

  Widget _studentApprovalList() {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.all(9),
          color: const Color.fromARGB(255, 16, 150, 246),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            tileColor: const Color.fromARGB(255, 149, 218, 239),
            title: Text(
              students[index]["name"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Reg No: ${students[index]["id"]}",
              style: const TextStyle(color: Colors.black),
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
              child: const Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Widget _pastRecords() {
    // Sample past records (replace with actual data)
    List<String> pastRecords = ["Record 1", "Record 2", "Record 3"];

    return ListView.builder(
      itemCount: pastRecords.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(9),
          color: const Color.fromARGB(255, 23, 117, 194),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          elevation: 10,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            tileColor: const Color.fromARGB(255, 136, 223, 255),
            title: Text(
              pastRecords[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FacultyHomePage(),
  ));
}
