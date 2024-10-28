
import 'package:cgas_official/pages/hod/screen/approval_list_page.dart';
import 'package:cgas_official/pages/hod/screen/past_records_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'hod_profile_page.dart';

class HodHomePage extends StatefulWidget {
  const HodHomePage({super.key});

  @override
  _HodHomePageState createState() => _HodHomePageState();
}

class _HodHomePageState extends State<HodHomePage> {
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
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      color: const Color.fromARGB(255, 3, 21, 41),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage('assets/images/default_profile.png') as ImageProvider,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HodProfilePage(),
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
                    'HOD',
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
        return const CombinedRequestsPage(); // Connect the Approval List page
      case 1:
        return const PastRecordsPage(); // Connect the Past Records page
      default:
        return const Text('Error');
    }
  }
}
