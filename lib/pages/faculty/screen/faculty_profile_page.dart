import 'package:flutter/material.dart';

class FacultyProfilePage extends StatelessWidget {
  const FacultyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text(
          'Faculty Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profilephoto.jpg'), // Add your image here
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Dr. John Doe', // Replace with actual name
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Teacher ID: 12345678', // Replace with actual teacher ID
                style: TextStyle(
                  fontSize: 16, color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Department: Computer Science', // Replace with actual department
                style: TextStyle(
                  fontSize: 16,color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Add additional content if needed
          ],
        ),
      ),
    );
  }
}
