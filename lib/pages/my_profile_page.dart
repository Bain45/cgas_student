import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Profile Information goes here',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
