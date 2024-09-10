import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Logout Page',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
