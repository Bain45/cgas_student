import 'package:flutter/material.dart';

class StudentToken extends StatelessWidget {
  final String studentName;
  final String studentId;

  const StudentToken({super.key, required this.studentName, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text('Student Token', style: TextStyle(color: Colors.white)
        ),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
          children: [
            SizedBox(height: 50.0),  // Add some top padding
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/profilephoto.jpg'),  // Placeholder photo
            ),
            const SizedBox(height: 16.0),
            Text(
              'Student Name: $studentName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Register Number: $studentId',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Reason: Attending Workshop',  // Example reason
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Pass Type: Inpass',  // Example pass type
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Time: 10:00 AM',  // Example time
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,  // Center buttons horizontally
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle approve action
                  },
                  child: const Text('Approve',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,  
                  ),
                ),
                const SizedBox(width: 30.0),  // Add some space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Handle reject action
                  },
                  child: const Text('  Reject  ',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,  
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
