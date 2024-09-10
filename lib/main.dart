import 'package:flutter/material.dart';
import 'pages/student_home_page.dart';
import 'pages/my_profile_page.dart';
import 'pages/logout_page.dart';
import 'pages/inpass_page.dart';
import 'pages/outpass_page.dart';
import 'pages/history_page.dart';
import 'pages/tokens_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Homepage',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      home: StudentHomePage(),
      routes: {
        '/myprofile': (context) => MyProfilePage(),
        '/logout': (context) => LogoutPage(),
        '/inpass': (context) => InpassPage(),
        '/outpass': (context) => OutpassPage(),
        '/history': (context) => HistoryPage(),
        '/tokens': (context) => TokensPage(),
      },
    );
  }
}
