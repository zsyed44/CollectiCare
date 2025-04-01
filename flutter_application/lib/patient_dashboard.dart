import 'package:flutter/material.dart';
import 'package:flutter_application/dashboard.dart';
import 'services/api_service.dart';
import 'test2.dart';

class PatientDashboard extends StatelessWidget {
  final String imagePath =
      "assets/collecticarelogo.png"; // Use a local asset image

//   PatientDashboard({super.key}); // Eye status example
  String patientID;
  String name;
  String dob;
  String eyeStatus;
  int age;
  PatientDashboard(
      {required this.patientID,
      required this.name,
      required this.dob,
      required this.eyeStatus,
      required this.age});

  // TEMPORARY PLACEHOLDER VALUES
  // final String name = "John Doe";
  // final String dob = "1995-08-15"; // YYYY-MM-DD
  // final int age = DateTime.now().year - 1995; // Auto-calculated age
  // final String eyeStatus = "Normal"; // Eye status example

  // String name = '', dob = '', eyeStatus = '';
  // int age = 0;

  // Future<Map<String, dynamic>> fetchPatientSummary() async {
  //   final response = await ApiService.get('/patient/$patientID/summary');
  //   if (response == null || response.containsKey("error")) {
  //     throw Exception("Failed to load data");
  //   }
  //   return response;
  // }

  // void setValues() async  {
  //   Map<String, dynamic> summary = await fetchPatientSummary();

  //   name = summary["name"];
  //   dob = summary["dob"];
  //   eyeStatus = summary["eyeStatus"];
  //   age = DateTime.now().year - int.parse(dob.substring(0, 4));
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async => false, // Prevents back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
          automaticallyImplyLeading: false, // Removes back arrow
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                // Show help information
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Help'),
                    content: Text(
                        'This is your profile information and test dashboard.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),

                  // Profile Picture with subtle shadow

                  // Name with a larger text style
                  Text(
                    name,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 6),

                  // Patient ID displayed subtly
                  Text(
                    "Patient ID: $patientID",
                    style: textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Info Cards
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black26
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.calendar_today,
                            "Date of Birth",
                            dob,
                          ),
                          Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Icons.cake,
                            "Age",
                            "$age years",
                          ),
                          Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Icons.visibility,
                            "Eye Status",
                            eyeStatus,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Action Buttons
                  SizedBox(height: 40),

// Start Test Button - Made wider and more substantial
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Dashboard(patientID: patientID),
                          ),
                        );
                      },
                      icon: Icon(Icons.medical_services_outlined, size: 24),
                      label: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Start Test',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

// Logout Button - Matching width and better proportions
                  Container(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      icon: Icon(Icons.logout, size: 24),
                      label: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          width: 1.5,
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Helper method to build consistent info rows
  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.blueAccent.withOpacity(0.2)
                : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
            size: 22,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
