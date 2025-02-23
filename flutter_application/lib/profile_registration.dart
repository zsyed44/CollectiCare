import 'package:flutter/material.dart';
import 'login.dart';
import 'services/api_service.dart';

class ProfileRegistration extends StatefulWidget {
  final String userId;
  ProfileRegistration({required this.userId});
  @override
  _ProfileRegistrationState createState() => _ProfileRegistrationState();
}

class _ProfileRegistrationState extends State<ProfileRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await ApiService.post('auth/register/profile', {
          'id': widget.userId,
          'name': _nameController.text,
          'dob': _dobController.text,
          'campLocation': _addressController.text,
          'phone': _phoneController.text,
        });

        if (response['success']) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => Login())
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  // Name validation (only letters)
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return "Name is required";
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return "Invalid name (letters only)";
    return null;
  }

  // Phone number validation (only digits)
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";
    if (!RegExp(r'^\d+$').hasMatch(value)) return "Invalid phone number (numbers only)";
    if (value.length < 10) return "Phone number must be at least 10 digits";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('REGISTER')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Name'),
                validator: _validateName,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  hintText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(hintText: 'Camp Location'),//location will be used for data access
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitProfile(),
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {     
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  }
                },
                child: Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
