
// import 'package:cgas_student/pages/hod/screen/hod_home_page.dart';
//import 'package:cgas_student/pages/faculty/screen/faculty_home_page.dart';
import 'package:cgas_student/pages/student/screen/student_home_page.dart';
import 'package:flutter/material.dart';
//import 'pages/student/screen/student_home_page.dart';
// import 'pages/security/screen/qr_code_scanner.dart';
import 'pages/student/screen/my_profile_page.dart';
import 'onboarding/login_page.dart';
import 'pages/student/screen/inpass_page.dart';
import 'pages/student/screen/outpass_page.dart';
import 'pages/student/screen/history_page.dart';
import 'pages/student/screen/tokens_page.dart';
import 'onboarding/forgot_pass.dart'; // Ensure the import for ForgotPasswordPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: StudentHomePage(), // Set StudentHomePage as the default route
      routes: {
        '/myprofile': (context) => const MyProfilePage(),
        '/inpass': (context) => const InpassPage(),
        '/outpass': (context) => const OutpassPage(),
        '/history': (context) => const HistoryPage(),
        '/tokens': (context) => const TokensPage(),
        '/login': (context) => const LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}
