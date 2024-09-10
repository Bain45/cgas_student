import 'package:flutter/material.dart';

class TokensPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concurrent Tokens'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTokenItem('Token 1234', 'Valid until 01/09/2024'),
            _buildTokenItem('Token 5678', 'Valid until 15/09/2024'),
            // Add more token items here
          ],
        ),
      ),
    );
  }

  Widget _buildTokenItem(String tokenNumber, String validity) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(tokenNumber, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(validity),
      ),
    );
  }
}
