import 'package:flutter/material.dart';

class SecurityHomePage extends StatefulWidget {
  @override
  _SecurityHomePageState createState() => _SecurityHomePageState();
}

class _SecurityHomePageState extends State<SecurityHomePage> {
  // Sample data, replace with API data
  List<Map<String, String>> passRequests = [
    {"name": "John Doe", "id": "S123", "time": "2:00 PM", "reason": "Library"},
    {"name": "Jane Smith", "id": "S124", "time": "3:30 PM", "reason": "Canteen"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Gatepass Authentication'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Student ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: passRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(passRequests[index]['name']!),
                    subtitle: Text(
                        'ID: ${passRequests[index]['id']} \nTime: ${passRequests[index]['time']} \nReason: ${passRequests[index]['reason']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () {
                            // Approve pass logic
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            // Reject pass logic
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
