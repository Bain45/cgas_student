import 'package:cgas_official/pages/faculty/screen/faculty_home_page.dart';
import 'package:cgas_official/pages/hod/screen/hod_home_page.dart';
import 'package:cgas_official/pages/security/screen/security_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgot_pass.dart'; // Import ForgotPasswordPage if it's in a separate file

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Controllers for email and password
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final FirebaseAuth auth = FirebaseAuth.instance;

    void navigate(String authId) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      print("Navogating: $authId");
      try {
        // Check in HOD collection
        DocumentSnapshot hodDoc =
            await firestore.collection('hod').doc(authId).get();
        if (hodDoc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HodHomePage()),
          );
          return; // Exit after successful navigation
        }

        // Check in Faculty collection
        DocumentSnapshot facultyDoc =
            await firestore.collection('faculity').doc(authId).get();
        if (facultyDoc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FacultyHomePage()),
          );
          return; // Exit after successful navigation
        }

        // Check in Security collection
        DocumentSnapshot securityDoc =
            await firestore.collection('security').doc(authId).get();
        if (securityDoc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SecurityHomePage()),
          );
          return; // Exit after successful navigation
        }

        // If no document found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No matching role found for this authId")),
        );
      } catch (e) {
        // Handle any errors that occur during the Firestore query
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    Future<void> login() async {
      if (formKey.currentState!.validate()) {
        try {
          // Try to sign in the user
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          // If successful, show success snackbar
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Login successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );

          print(userCredential.user!.uid);

          navigate(userCredential.user!.uid);
        } on FirebaseAuthException catch (e) {
          String errorMessage;

          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided.';
          } else {
            errorMessage = 'An error occurred. Please try again.';
          }

          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Login Page',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Log In',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Navigate to ForgotPasswordPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                  ),
                  const Text('|'),
                  TextButton(
                    onPressed: () {
                      // Navigate to the Sign Up page (implement it in a separate file)
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
