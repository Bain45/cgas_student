import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/studenthome5.jpg', // Path to your background image
              fit: BoxFit.cover, // Cover the whole screen
            ),
          ),
          // Your main content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0), // Add padding to move the Container down
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.account_circle_rounded, color: const Color.fromARGB(255, 249, 203, 253), size: 40.0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/myprofile');
                        },
                      ),
                      Text(
                        'CGAS',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 249, 203, 253),
                          fontSize: 28,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout_sharp, color: const Color.fromARGB(255, 249, 203, 253), size: 35.0),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/logout');
                        },
                      ),
                    ],
                  ),
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
                      _buildCard(context, Icons.arrow_circle_down, 'INPASS', '/inpass', const Color.fromARGB(255, 249, 203, 253), const Color.fromARGB(255, 0, 0, 0)),
                      _buildCard(context, Icons.arrow_circle_up, 'OUTPASS', '/outpass', const Color.fromARGB(255, 249, 203, 253), const Color.fromARGB(255, 0, 0, 0)),
                    ],
                  ),
                ),
              ),
              // Adjust padding above the History section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust vertical padding to move it higher
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Adjust padding for history items
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
                  color: const Color.fromARGB(255, 243, 158, 250), // Background color of the container
                  padding: EdgeInsets.all(16.0), // Padding inside the container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.token, color: const Color.fromARGB(255, 0, 0, 0), size: 30.0), // Token icon
                      SizedBox(width: 10.0), // Spacing between icon and text
                      Text(
                        'Concurrent Tokens',
                        style: TextStyle(fontSize: 20.0, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String status) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Margin around each item
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 254, 187, 239), // Background color of the container
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        border: Border.all(
          color: Colors.grey[300]!, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding inside the container
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          'Status: $status',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0), // Subtitle color
            fontSize: 14.0,
          ),
        ),
        trailing: Text(
          '1m ago', // Example timestamp or additional info
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0), // Timestamp color
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

