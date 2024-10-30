import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentAddPage extends StatefulWidget {
  final String facultyId; // Add facultyId parameter

  const StudentAddPage({super.key, required this.facultyId}); // Update constructor

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

  Map<String, String> yearMap = {};
  String? selectedYearId;

  @override
  void initState() {
    super.initState();
    _fetchYear();
  }

  Future<void> _fetchYear() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('academicYears').get();
      setState(() {
        yearMap = {
          for (var doc in querySnapshot.docs) doc.id: doc['academicYear'],
        };
      });
    } catch (e) {
      print("Error fetching academic years: $e");
      Fluttertoast.showToast(
        msg: "Error fetching academic years",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Method to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

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
      // Get the currently authenticated user's UID as facultyId
      String facultyId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch department ID based on facultyId
      String departmentId = await _fetchDepartmentId(facultyId);

      // Upload image to Firebase Storage and get the image URL
      final storageRef = FirebaseStorage.instance.ref().child('student_photos/${_selectedImage!.name}');
      await storageRef.putFile(File(_selectedImage!.path));
      imageUrl = await storageRef.getDownloadURL();

      // Create the user in Firebase Auth and get the UID
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the student UID
      String studentUid = userCredential.user!.uid; // Get the student UID

      // Save additional details in Firestore under "students" collection
      DocumentReference studentRef = FirebaseFirestore.instance.collection('students').doc(studentUid); // Use the student UID as the document ID

      await studentRef.set({
        'name': nameController.text,
        'regnum': regnumController.text,
        'email': emailController.text,
        'contact': contactController.text,
        'gender': _gender,
        'dob': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'year': selectedYearId,
        'imageUrl': imageUrl,
        'facultyId': facultyId, // Store the faculty ID
        'studentUid': studentUid, // Store the student UID
        'departmentId': departmentId, // Store the department ID
      });

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add student.')),
      );
    }
  }
}

// Method to fetch department ID based on faculty ID
Future<String> _fetchDepartmentId(String facultyId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance.collection('faculty').doc(facultyId).get();

    if (docSnapshot.exists) {
      // Assuming the departmentId is stored as a field in the faculty document
      return docSnapshot['departmentId']; // Adjust the key if necessary
    } else {
      throw Exception("Faculty document does not exist for the given faculty ID");
    }
  } catch (e) {
    print("Error fetching department ID: $e");
    Fluttertoast.showToast(
      msg: "Error fetching department ID",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    rethrow; // Rethrow the exception for further handling if needed
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      appBar: AppBar(
        title: const Text('Add Student',style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41), // Set AppBar color
        iconTheme: const IconThemeData(color: Colors.white),
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
                        backgroundColor: const Color.fromARGB(255, 124, 213, 249),
                        backgroundImage: _selectedImage != null
                            ? FileImage(File(_selectedImage!.path))
                            : const AssetImage('assets/dummy-profile-pic.png') as ImageProvider,
                        child: _selectedImage == null
                            ? const Icon(
                                Icons.photo,
                                size: 40,
                                color: Color.fromARGB(255, 255, 255, 255),
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
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 124, 213, 249),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
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
                decoration: InputDecoration(
                  labelText: 'Register Number',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 124, 213, 249),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
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
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 124, 213, 249),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
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
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 124, 213, 249),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
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
              const Text('Gender', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 124, 213, 249))), // Gender label color
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male', style: TextStyle(color: Color.fromARGB(255, 124, 213, 249))), // Male label color
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
                      title: const Text('Female', style: TextStyle(color: Color.fromARGB(255, 124, 213, 249))), // Female label color
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
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 124, 213, 249),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
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

              DropdownButtonFormField<String>(
                value: selectedYearId,
                decoration: InputDecoration(
                  labelText: "Academic Year",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 124, 213, 249),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
                ),
                items: yearMap.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value, style: const TextStyle(color: Colors.black)), // Year color
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYearId = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an academic year';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 124, 213, 249),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Label color
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 124, 213, 249), // Button color
                  padding: const EdgeInsets.symmetric(vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Button border radius
                  ),
                ),
                child: const Text('Add Student', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18)), // Button text color and size
              ),
            ],
          ),
        ),
      ),
    );
  }
} 