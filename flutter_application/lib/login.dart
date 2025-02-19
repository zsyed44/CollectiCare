import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'patient_dashboard.dart';
import 'services/api_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Uint8List? _imageData;
  final picker = ImagePicker();
  bool _isLoggingIn = false;
  final _idController = TextEditingController();

  Future<void> login() async {
    if (_imageData == null) return;

    setState(() => _isLoggingIn = true);

    try {
      final response = await ApiService.post('auth/login', {
        'id': _idController.text,
        'photo': base64Encode(_imageData!)
      });

      if (response['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
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

      await Future.delayed(Duration(seconds: 3)); // Simulate login delay

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientDashboard()),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: 'Enter ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoggingIn ? null : pickImage,
              child: Text(_isLoggingIn ? 'Logging in...' : 'Upload Photo to Login'),
            ),
            if (_imageData != null) 
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.memory(_imageData!, height: 100),
              ),
          ],
        ),
      ),
    );
  }
}