import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  String name = 'Loading...';
  String image = '';

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (user == null) {
      print("User is not logged in.");
      return;
    }
    final userId = user!.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot studentDoc = await firestore.collection('students').doc(userId).get();

      if (studentDoc.exists) {
        final data = studentDoc.data() as Map<String, dynamic>?;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 20, 44),
      body: Column(
        children: [
          _buildProfileHeader(),
          Expanded(
            child: _buildMainContent(),
          ),
          _buildTokenSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, color: Colors.white, size: 30.0),
            onPressed: () {
              Navigator.pushNamed(context, '/myprofile');
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CGAS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Welcome, ',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app_sharp, color: Colors.white, size: 30.0),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
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

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: [
                _buildCard(context, Icons.arrow_circle_down, 'INPASS', '/inpass'),
                _buildCard(context, Icons.arrow_circle_up, 'OUTPASS', '/outpass'),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        _buildHistorySection(),
      ],
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String label, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        color: const Color.fromARGB(255, 163, 234, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80.0, color: const Color.fromARGB(255, 4, 20, 44)),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: [
          _buildHistoryItem('Inpass Request - 01/08/2024', 'Approved'),
          _buildHistoryItem('Outpass Request - 05/08/2024', 'Pending'),
          _buildHistoryItem('Inpass Request - 10/08/2024', 'Denied'),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 163, 234, 255),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!, width: 1.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Text('Status: $status', style: const TextStyle(fontSize: 14.0)),
        trailing: const Text('1m ago', style: TextStyle(fontSize: 12.0)),
        onTap: () {
          print('Tapped on $title');
        },
      ),
    );
  }

  Widget _buildTokenSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/tokens');
      },
      child: Container(
        color: const Color.fromARGB(255, 163, 234, 255),
        padding: const EdgeInsets.all(16.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_2, color: Color.fromARGB(255, 4, 20, 44), size: 30.0),
            SizedBox(width: 10.0),
            Text(
              'Tokens',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
