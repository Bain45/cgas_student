import 'package:flutter/material.dart';

class SecurityHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InpassRequestsPage()),
                );
              },
              child: Text('Inpass Requests'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OutpassRequestsPage()),
                );
              },
              child: Text('Outpass Requests'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add more navigation options as needed
              },
              child: Text('Other Options'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy pages for navigation
class InpassRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inpass Requests'),
      ),
      body: Center(
        child: Text('Inpass Requests List Here'),
      ),
    );
  }
}

class OutpassRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outpass Requests'),
      ),
      body: Center(
        child: Text('Outpass Requests List Here'),
      ),
    );
  }
}
