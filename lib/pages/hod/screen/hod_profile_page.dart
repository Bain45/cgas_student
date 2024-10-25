import 'package:flutter/material.dart';

class HodProfilePage extends StatelessWidget {
  const HodProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text(
          'Hod Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profilephoto.jpg'), // Replace with actual image
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Dr. John Doe', // Replace with actual name
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Hod ID: 12345678', // Replace with actual ID
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 124, 213, 249),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Department: Computer Science', // Replace with actual department
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 20),
            _buildProfileSectionTitle('Contact Information'),
            const SizedBox(height: 10),
            _buildProfileInfoRow(Icons.email, 'Email', 'john.doe@example.com'),
            const SizedBox(height: 10),
            _buildProfileInfoRow(Icons.phone, 'Phone', '+123 456 7890'),
            const SizedBox(height: 30),
            _buildProfileSectionTitle('Bio'),
            const SizedBox(height: 10),
            const Text(
              'Dr. John Doe is a highly experienced educator in the field of Computer Science, with a focus on network security and machine learning.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileSectionTitle('Skills & Expertise'),
            const SizedBox(height: 10),
            _buildSkillsChips(['Network Security', 'Machine Learning', 'Flutter Development']),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String info) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 124, 213, 249)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        Expanded(
          child: Text(
            info,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsChips(List<String> skills) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills
          .map(
            (skill) => Chip(
              label: Text(skill),
              backgroundColor: const Color.fromARGB(255, 124, 213, 249),
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 3, 21, 41),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          .toList(),
    );
  }
}
