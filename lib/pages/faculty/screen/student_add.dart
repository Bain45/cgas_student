import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentAddPage extends StatefulWidget {
  const StudentAddPage({super.key});

  @override
  _StudentAddPageState createState() => _StudentAddPageState();
}

class _StudentAddPageState extends State<StudentAddPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController regnumController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _gender;
  DateTime? _selectedDate;
  XFile? _selectedImage;
  String? imageUrl;

  // Method to pick an image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  // Method to select the date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method to save student to Firestore
  Future<void> _saveStudentToFirestore() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      try {
        // Get the currently authenticated user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Retrieve faculty information from Firestore
          DocumentSnapshot facultySnapshot = await FirebaseFirestore.instance
              .collection('faculty') // Change this to your faculty collection name
              .doc(user.uid) // Assuming the document ID is the same as the user's UID
              .get();

          if (facultySnapshot.exists) {
            String facultyId = facultySnapshot.id; // Get the faculty ID
            String departmentId = facultySnapshot['departmentId']; // Get the department ID

            // Upload image to Firebase Storage and get the image URL
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('student_photos/${_selectedImage!.name}');
            await storageRef.putFile(File(_selectedImage!.path));
            imageUrl = await storageRef.getDownloadURL();

            // Create the user in Firebase Auth and get the UID
            UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

            // Get the student UID
            String studentUid = userCredential.user!.uid; // Get the student UID

            // Save additional details in Firestore under "students" collection
            DocumentReference studentRef = FirebaseFirestore.instance
                .collection('students')
                .doc(studentUid); // Use the student UID as the document ID

            await studentRef.set({
              'name': nameController.text,
              'regnum': regnumController.text,
              'email': emailController.text,
              'contact': contactController.text,
              'gender': _gender,
              'dob': DateFormat('yyyy-MM-dd').format(_selectedDate!),
              'imageUrl': imageUrl,
              'facultyId': facultyId, // Save the retrieved faculty ID
              'departmentId': departmentId, // Save the retrieved department ID
              'studentUid': studentUid, // Store the student UID
            });

            // Success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Student added successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Faculty not found.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated.')),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add student.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xff4c505b),
                        backgroundImage: _selectedImage != null
                            ? FileImage(File(_selectedImage!.path))
                            : const AssetImage('assets/dummy-profile-pic.png')
                                as ImageProvider,
                        child: _selectedImage == null
                            ? const Icon(
                                Icons.add,
                                size: 40,
                                color: Color.fromARGB(255, 134, 134, 134),
                              )
                            : null,
                      ),
                      if (_selectedImage != null)
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Register Number field
              TextFormField(
                controller: regnumController,
                decoration: const InputDecoration(
                  labelText: 'Register Number',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the register number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contact Number field
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender field
              const Text('Gender', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date of Birth field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _saveStudentToFirestore,
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
