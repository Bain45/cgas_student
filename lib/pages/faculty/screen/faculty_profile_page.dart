import 'package:flutter/material.dart';

class FacultyProfilePage extends StatelessWidget {
  const FacultyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Profile'),
        backgroundColor: const Color.fromARGB(255, 7, 37, 81),
      ),
      body: Center(
        child: Text(
          'Profile Page Content Here',  // Replace with actual profile content
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
