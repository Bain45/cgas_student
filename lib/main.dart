import 'package:cgas_official/firebase_options.dart';
import 'package:cgas_official/onboarding/forgot_pass.dart';
import 'package:cgas_official/onboarding/login_page.dart';
//import 'package:cgas_official/pages/faculty/screen/faculty_home_page.dart';
//import 'package:cgas_official/pages/student/screen/student_home_page.dart';
import 'package:cgas_official/pages/student/screen/history_page.dart';
import 'package:cgas_official/pages/student/screen/inpass_page.dart';
import 'package:cgas_official/pages/student/screen/my_profile_page.dart';
import 'package:cgas_official/pages/student/screen/outpass_page.dart';
import 'package:cgas_official/pages/student/screen/tokens_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Homepage',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      home: const LoginPage(), // Set StudentHomePage as the default route
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
