import 'package:flutter/material.dart';

class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 20, 44),
      appBar: AppBar(
        title: const Text('Concurrent Tokens',style: TextStyle(color: Colors.white
        ),),
        backgroundColor: const Color.fromARGB(255, 4, 20, 44),
        iconTheme: const IconThemeData(color: Colors.white),
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
      color: const Color.fromARGB(255, 163, 234, 255),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(tokenNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(validity),
      ),
    );
  }
}
