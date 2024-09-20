import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 20, 44),
      body: Container(
        child: 
            Column(
              children: [
                // First container to start from the top with a background color
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0), // Padding inside the container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.account_circle_rounded, color: Color.fromARGB(255, 255, 255, 255), size: 30.0),
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
              children: const [
                Text(
                  'Welcome, ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Abin M Biju',
                  style: TextStyle(
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
                        icon: const Icon(Icons.exit_to_app_sharp, color: Color.fromARGB(255, 255, 255, 255), size: 30.0),
                        onPressed: () {
                          _showLogoutConfirmationDialog(context); // Call the method to show the dialog
                        },
                      ),
                    ],
                  ),
                ),
                // Inpass & Outpass Using BUILDCARD
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      children: [
                        _buildCard(context, Icons.arrow_circle_down, 'INPASS', '/inpass', const Color.fromARGB(255, 163, 234, 255), const Color.fromARGB(255, 4, 20, 44)),
                        _buildCard(context, Icons.arrow_circle_up, 'OUTPASS', '/outpass', const Color.fromARGB(255, 163, 234, 255), const Color.fromARGB(255, 4, 20, 44)),
                      ],
                    ),
                  ),
                ),
                // Adjust padding above the History section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust vertical padding to move it higher
                  child: Text(
                    'History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Adjust padding for history items
                    children: [
                      _buildHistoryItem('Inpass Request - 01/08/2024', 'Approved'),
                      _buildHistoryItem('Outpass Request - 05/08/2024', 'Pending'),
                      _buildHistoryItem('Inpass Request - 10/08/2024', 'Denied'),
                      // Add more history items here
                    ],
                  ),
                ),
                // Concurrent Tokens Section at the bottom
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/tokens'); // Navigate to the tokens page
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 163, 234, 255), // Background color of the container
                    padding: const EdgeInsets.all(16.0), // Padding inside the container
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, color: Color.fromARGB(255, 4, 20, 44), size: 30.0), // Token icon
                        SizedBox(width: 10.0), // Spacing between icon and text
                        Text(
                          'Tokens',
                          style: TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 4, 20, 44), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login'); // Perform logout
              },
            ),
          ],
        );
      },
    );
  }

  // Existing methods for building cards and history items
  Widget _buildCard(BuildContext context, IconData icon, String label, String routeName, Color cardColor, Color iconColor) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        color: cardColor, // Set the card background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80.0, color: iconColor), // Set the icon color
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin around each item
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 163, 234, 255), // Background color of the container
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        border: Border.all(
          color: Colors.grey[300]!, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding inside the container
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          'Status: $status',
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), // Subtitle color
            fontSize: 14.0,
          ),
        ),
        trailing: const Text(
          '1m ago', // Example timestamp or additional info
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), // Timestamp color
            fontSize: 12.0,
          ),
        ),
        onTap: () {
          // Handle row tap if needed
          print('Tapped on $title');
        },
      ),
    );
  }
}
