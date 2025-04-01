import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'profile_registration.dart';
import 'services/api_service.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

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

      await Future.delayed(Duration(seconds: 3)); // Simulate login delay

      // Automatically navigate to profile registration page after photo upload
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileRegistration(userId: _idController.text)));

      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _validateID(String value) {
    setState(() {
      _isValidID =
          RegExp(r'^\d{12}$').hasMatch(value); // Checks for exactly 12 digits
    });
  }

  Future<void> _uploadPhoto() async {
    // Needs to be altered to follow the new API
    if (!_isValidID) return;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });

      try {
        final response = await ApiService.post('auth/register/photo',
            {'id': _idController.text, 'photo': base64Encode(_imageBytes!)});

        if (response['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileRegistration(userId: _idController.text)),
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
      appBar: AppBar(
        title: Text('Register'),
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
                      'Register New Patient',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please enter the ID number and upload a photo.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        hintText: 'Enter 12-digit ID Number',
                        prefixIcon:
                            Icon(Icons.perm_identity, color: Colors.blueAccent),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged:
                          _validateID, // Call validation function on input change
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isValidID
                          ? pickImage
                          : null, // Disable button if invalid
                      icon: Icon(Icons.camera_alt, size: 20),
                      label: Text('Upload Photo to Register Patient'),
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(double.infinity, 50), // Full width button
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (_imageBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(_imageBytes!, height: 100),
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
