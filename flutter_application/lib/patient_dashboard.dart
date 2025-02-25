import 'package:flutter/material.dart';
import 'package:flutter_application/dashboard.dart';
import 'services/api_service.dart';


class PatientDashboard extends StatelessWidget {

  final String imagePath = "assets/profile.jpg"; // Use a local asset image

//   PatientDashboard({super.key}); // Eye status example
  String patientID;
  String name;
  String dob;
  String eyeStatus;
  int age;
  PatientDashboard({required this.patientID, required this.name, required this.dob, required this.eyeStatus, required this.age});


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
    return WillPopScope(
      onWillPop: () async => false, // Prevents back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Information'),
          automaticallyImplyLeading: false, // Removes back arrow
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: <Widget>[
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(imagePath), // Load from assets
                ),
                SizedBox(height: 20),

                // Display Name
                Text(
                  "Name: $name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Display Date of Birth
                Text(
                  "Date of Birth: $dob",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),

                // Eye Status Below Date of Birth
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5),
                    Text(
                      "Eye Status: $eyeStatus",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Display Age
                Text(
                  "Age: $age",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30),

                // Start Test Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                  child: Text('Start Test'),
                ),
                SizedBox(height: 30),

                // Logout Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
