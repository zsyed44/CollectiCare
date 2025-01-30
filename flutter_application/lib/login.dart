import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dashboard.dart'; // Import your dashboard screen

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Uint8List? _imageData;
  final picker = ImagePicker();
  bool _isLoggingIn = false;

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
        MaterialPageRoute(builder: (context) => Dashboard()),
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
            ElevatedButton(
              onPressed: _isLoggingIn ? null : pickImage,
              child: Text(_isLoggingIn ? 'Logging in...' : 'Upload Photo to Login'),
            ),
            if (_imageData != null) Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.memory(_imageData!, height: 100), // Show image
            ),
          ],
        ),
      ),
    );
  }
}