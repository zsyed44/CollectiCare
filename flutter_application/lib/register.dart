import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'profile_registration.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  final TextEditingController _idController = TextEditingController();
  bool _isValidID = false;

  Future<void> pickImage() async {
    if (!_isValidID) return; // Ensure button can't be clicked when disabled
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _validateID(String value) {
    setState(() {
      _isValidID = RegExp(r'^\d{12}$').hasMatch(value); // Checks for exactly 12 digits
    });
  }

  Future<void> _uploadPhoto() async {
    if (!_isValidID) return;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });

      try {
        final response = await ApiService.post('auth/register/photo', {
          'id': _idController.text,
          'photo': base64Encode(_imageBytes!)
        });

        if (response['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileRegistration(userId: _idController.text)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo upload failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('REGISTER')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(hintText: 'Enter 12-digit ID Number'),
              keyboardType: TextInputType.number,
              onChanged: _validateID, // Call validation function on input change
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isValidID ? pickImage : null, // Disable button if invalid
              child: Text('Upload Photo'),
            ),
            if (_imageBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.memory(_imageBytes!, height: 100),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileRegistration()));
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
