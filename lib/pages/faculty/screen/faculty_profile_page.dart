import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacultyProfilePage extends StatelessWidget {
  const FacultyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('faculty') // Change to your collection name
                  .doc(user.uid) // Use the user's UID to get their document
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No profile data found.'));
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                String departmentId = userData['departmentId'] ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          userData['imageUrl'] ?? '//cgas-2024.appspot.com/faculty_images',
                        ),
                        onBackgroundImageError: (_, __) => const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        userData['name'] ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Fetch department name based on departmentId
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('department') // Change to your departments collection name
                          .doc(departmentId) // Use the department ID to get the department document
                          .get(),
                      builder: (context, departmentSnapshot) {
                        if (departmentSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (departmentSnapshot.hasError) {
                          return Center(child: Text('Error: ${departmentSnapshot.error}'));
                        }
                        if (!departmentSnapshot.hasData || !departmentSnapshot.data!.exists) {
                          return const Center(child: Text('Department not found.'));
                        }

                        final departmentData = departmentSnapshot.data!.data() as Map<String, dynamic>;
                        return Center(
                          child: Text(
                            'Department: ${departmentData['department'] ?? 'N/A'}', // Change 'department' to the appropriate field in your department document
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Email : ${userData['email'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Contact : ${userData['phone'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                  ],
                );
              },
            )
          : const Center(child: Text('User not logged in.')),
    );
  }
}
