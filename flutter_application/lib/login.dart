import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'patient_dashboard.dart';
import 'services/api_service.dart';
//import 'temporary_page.dart';
import 'healthWorker_login.dart';

String thisCity = selectedCity;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Uint8List? _imageData;
  final picker = ImagePicker();
  bool _isLoggingIn = false;
  final _idController = TextEditingController();

  String name = '', dob = '', eyeStatus = '';
  int age = 0;

  Future<void> fetchAndSetValues(patientID) async {
    try {
      final response = await ApiService.get('patient/$patientID/summary');
      if (response == null || response.containsKey("error")) {
        throw Exception("Failed to load data");
      }
      print(response);

      name = response["Name"];
      dob = response["DOB"].split(
          "T")[0]; // The split is to remove the time component from the DOB
      eyeStatus = response["Eye Status"];
      age = DateTime.now().year - int.parse(dob.substring(0, 4));
      print("Name: $name, DOB: $dob, Eye Status: $eyeStatus, Age: $age");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> login() async {
    if (_imageData == null) return;

    setState(() => _isLoggingIn = true);

    try {
      String id = _idController.text;
      final response = await ApiService.get('patient/$id/$thisCity');

      if (response != null && response['patientID'] != null) {
        await fetchAndSetValues(id);
        print("Name: $name, DOB: $dob, Eye Status: $eyeStatus, Age: $age");

        await Future.delayed(Duration(seconds: 3)); // Simulate login delay
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PatientDashboard(
                  patientID: id,
                  name: name,
                  dob: dob,
                  eyeStatus: eyeStatus,
                  age: age)),
        );
      } else {
        // If the patient is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient not found or does not exist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes(); // Convert image to bytes
      setState(() {
        _imageData = bytes;
        _isLoggingIn = true; // Show loading state
      });

      login(); // Call the login function

      // await Future.delayed(Duration(seconds: 3)); // Simulate login delay

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => PatientDashboard(userId: _idController.text)),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true, // Centers the title for a modern feel
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 24), // Adds horizontal padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Card-like container for form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please enter your ID and upload a photo to login.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        hintText: 'Enter ID',
                        prefixIcon:
                            Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isLoggingIn ? null : pickImage,
                      icon: Icon(Icons.camera_alt, size: 20),
                      label: Text(_isLoggingIn
                          ? 'Logging in...'
                          : 'Upload Photo to Login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(double.infinity, 50), // Full width button
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (_imageData != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(_imageData!, height: 100),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
