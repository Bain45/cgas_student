import 'package:cgas_official/pages/security/screen/qr_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityHomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> _getUserData() async {
    if (_auth.currentUser != null) {
      final userId = _auth.currentUser!.uid;
      return await _firestore.collection('security').doc(userId).get();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 20, 44),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 20, 44),
        title: const Text(
          'CGAS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Error fetching user data',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          // Retrieve the user data
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] ?? 'User';
          final userImageUrl = userData['imageUrl'] ?? '';

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (userImageUrl.isNotEmpty)
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(userImageUrl),
                    ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Icon(
                Icons.qr_code_scanner,
                size: 100.0,
                color: Color.fromARGB(255, 163, 234, 255),
              ),
              const SizedBox(height: 20),
              const Text(
                'Click below to open scanner',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 4, 20, 44),
                  backgroundColor: const Color.fromARGB(255, 163, 234, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                onPressed: () {
                  // Navigate to scanner page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScannerPage(),
                    ),
                  );
                },
                child: const Text(
                  'Open Scanner',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
