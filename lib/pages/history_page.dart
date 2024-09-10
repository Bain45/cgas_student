import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHistoryItem('Inpass Request - 01/08/2024', 'Approved'),
            _buildHistoryItem('Outpass Request - 05/08/2024', 'Pending'),
            _buildHistoryItem('Inpass Request - 10/08/2024', 'Denied'),
            // Add more history items here
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String status) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Status: $status'),
      ),
    );
  }
}
