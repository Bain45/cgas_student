import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentaddPage extends StatefulWidget {
  const StudentaddPage({super.key});

  @override
  _StudentaddPageState createState() => _StudentaddPageState();
}

class _StudentaddPageState extends State<StudentaddPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController regnumController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _gender;
  DateTime? _selectedDate;
  XFile? _selectedImage;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 163, 234, 255), // Header background color
              onPrimary: Color.fromARGB(255, 3, 21, 41), // Header text color
              onSurface: Color.fromARGB(255, 163, 234, 255), // Body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // Wrap the Form in a Column
          children: [
            const SizedBox(height: 30), // Add space between the app bar and the form
            Expanded(
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
                                      : _imageUrl != null
                                          ? NetworkImage(_imageUrl!)
                                          : const AssetImage(
                                                  'assets/dummy-profile-pic.png')
                                              as ImageProvider,
                                  child: _selectedImage == null &&
                                          _imageUrl == null
                                      ? const Icon(
                                          Icons.add,
                                          size: 40,
                                          color: Color.fromARGB(
                                              255, 134, 134, 134),
                                        )
                                      : null,
                                ),
                                if (_selectedImage != null || _imageUrl != null)
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
                        border: UnderlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 163, 234, 255), // Background color of text field
                      ),
                      style: const TextStyle(color: Colors.black), // Text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
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
                        border: UnderlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 163, 234, 255),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your register number';
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
                        border: UnderlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 163, 234, 255),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
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
                        border: UnderlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 163, 234, 255),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Gender',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), // Text color
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Male', style: TextStyle(color: Colors.white)), // Text color
                            value: 'Male',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 163, 234, 255),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Female', style: TextStyle(color: Colors.white)), // Text color
                            value: 'Female',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 163, 234, 255),
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: _selectedDate == null
                                ? 'Date of Birth'
                                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            border: const UnderlineInputBorder(),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 163, 234, 255),
                          ),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: UnderlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 163, 234, 255),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                          print('Name: ${nameController.text}');
                          print('Register Number: ${regnumController.text}');
                          print('Email: ${emailController.text}');
                          print('Contact Number: ${contactController.text}');
                          print('Gender: $_gender');
                          print('Date of Birth: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}');
                          print('Password: ${passwordController.text}');
                        }
                      },style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 163, 234, 255),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      child: const Text('Add Student',style: TextStyle(color: Color.fromARGB(255, 3, 21, 41),fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
