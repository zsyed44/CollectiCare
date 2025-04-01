import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'home.dart';

String selectedCity = "";

class HealthWorkerLoginPage extends StatefulWidget {
  @override
  _HealthWorkerLoginPageState createState() => _HealthWorkerLoginPageState();
}

class _HealthWorkerLoginPageState extends State<HealthWorkerLoginPage> {
  final _workerIDController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  // Function to check credentials by calling the API using ApiService
  Future<void> checkCredentials(String workerID, String password) async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Reset error message
    });

    final endpoint =
        'campWorkers/$workerID/checkPassword/$password'; // Endpoint to check credentials
    try {
      final response = await ApiService.get(
          endpoint); // Make the GET request using ApiService
      print(response); // Print the response for debugging

      if (response['message'] == 'Password match!') {
        // Successful login, navigate to the dashboard
        selectedCity= response['location'];
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          errorMessage = 'Invalid worker ID or password!';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Worker Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _workerIDController,
              decoration: InputDecoration(
                labelText: 'Worker ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  String workerID = _workerIDController.text.trim();
                  String password = _passwordController.text.trim();

                  if (workerID.isNotEmpty && password.isNotEmpty) {
                    checkCredentials(
                        workerID, password); // Call the checkCredentials method
                  } else {
                    setState(() {
                      errorMessage =
                          'Please enter both worker ID and password.';
                    });
                  }
                },
                child: Text('Login'),
              ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
