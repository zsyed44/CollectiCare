import 'package:flutter/material.dart';
import 'test1.dart';
import 'test2.dart';
import 'test3.dart';
import 'test4.dart';
import 'test5.dart';
import 'test1b.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Track which tests have been completed
  bool test1Completed = false;
  bool test2Completed = false;
  bool test3Completed = false;
  bool test4Completed = false;
  bool test5Completed = false;

  // Function to check if all tests are completed
  bool get allTestsCompleted =>
      test1Completed && test2Completed && test3Completed && test4Completed && test5Completed;

  void updateTestStatus(int testNumber) {
    setState(() {
      if (testNumber == 1) test1Completed = true;
      if (testNumber == 2) test2Completed = true;
      if (testNumber == 3) test3Completed = true;
      if (testNumber == 4) test4Completed = true;
      if (testNumber == 5) test5Completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text('DASHBOARD'),
          automaticallyImplyLeading: false, // Removes the back arrow
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Welcome to the Dashboard!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),

                // Test Buttons
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InitialScreening()));
                    if (result == true) updateTestStatus(1);
                  },
                  child: Text('Initial Questionnaire'),
                  style: ElevatedButton.styleFrom(backgroundColor: test1Completed ? Colors.green : Colors.blue),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Test2()));
                    if (result == true) updateTestStatus(2);
                  },
                  child: Text('Test 2'),
                  style: ElevatedButton.styleFrom(backgroundColor: test2Completed ? Colors.green : Colors.blue),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Test3()));
                    if (result == true) updateTestStatus(3);
                  },
                  child: Text('Test 3'),
                  style: ElevatedButton.styleFrom(backgroundColor: test3Completed ? Colors.green : Colors.blue),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Test4()));
                    if (result == true) updateTestStatus(4);
                  },
                  child: Text('Test 4'),
                  style: ElevatedButton.styleFrom(backgroundColor: test4Completed ? Colors.green : Colors.blue),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Test5()));
                    if (result == true) updateTestStatus(5);
                  },
                  child: Text('Test 5'),
                  style: ElevatedButton.styleFrom(backgroundColor: test5Completed ? Colors.green : Colors.blue),
                ),
                SizedBox(height: 30),

                // Final Upload Button (Only enabled when all tests are completed)
                ElevatedButton(
                  onPressed: allTestsCompleted
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Final Upload Successful!")),
                          );
                        }
                      : null,
                  child: Text('Final Upload'),
                  style: ElevatedButton.styleFrom(backgroundColor: allTestsCompleted ? Colors.green : Colors.grey),
                ),
                SizedBox(height: 20),

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
