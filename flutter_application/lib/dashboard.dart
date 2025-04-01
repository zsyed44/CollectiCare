import 'package:flutter/material.dart';
import 'test1.dart';
import 'test2.dart';
import 'test3.dart';
import 'test4.dart';
import 'test5.dart';
import 'test1b.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({super.key});

  String patientID;
  Dashboard({required this.patientID});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Track which tests have been completed
  bool test1Completed = false;
  bool test2Completed = false;
  bool test3Completed = false;
  bool test4Completed = false;

  // Function to check if all tests are completed
  bool get allTestsCompleted =>
      test1Completed && test2Completed && test3Completed && test4Completed;

  void updateTestStatus(int testNumber) {
    setState(() {
      if (testNumber == 1) test1Completed = true;
      if (testNumber == 2) test2Completed = true;
      if (testNumber == 3) test3Completed = true;
      if (testNumber == 4) test4Completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DASHBOARD',
              style: TextStyle(fontWeight: FontWeight.w600)),
          automaticallyImplyLeading: false, // Removes the back arrow
          actions: [
            // Profile icon in app bar
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {
                // Show dialog with option to navigate to patient dashboard
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Options'),
                      content: Text(
                          'Would you like to return to the Patient Dashboard?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            Navigator.pop(context);

                            // Navigate to dashboard
                          },
                          child: Text('Go to Dashboard'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Welcome card with user info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Patient ID: ${widget.patientID}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildProgressIndicator(),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_calculateProgress()}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tests completed',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section title
                Text(
                  'Required Tests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Test cards in a grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTestCard(
                      title: 'Initial Questionnaire',
                      icon: Icons.assignment_outlined,
                      isCompleted: test1Completed,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InitialScreening(patientID: widget.patientID),
                          ),
                        );
                        if (result == true) updateTestStatus(1);
                      },
                    ),
                    _buildTestCard(
                      title: 'Eye Test',
                      icon: Icons.visibility_outlined,
                      isCompleted: test2Completed,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageEyeTest(patientID: widget.patientID),
                          ),
                        );
                        if (result == true) updateTestStatus(2);
                      },
                    ),
                    _buildTestCard(
                      title: 'Test 3',
                      icon: Icons.medical_services_outlined,
                      isCompleted: test3Completed,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Test3()),
                        );
                        if (result == true) updateTestStatus(3);
                      },
                    ),
                    _buildTestCard(
                      title: 'Test 4',
                      icon: Icons.science_outlined,
                      isCompleted: test4Completed,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Test4()),
                        );
                        if (result == true) updateTestStatus(4);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Final upload button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: allTestsCompleted
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Final Upload Successful!")),
                            );
                          }
                        : null,
                    icon: Icon(Icons.cloud_upload_outlined),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'UPLOAD TEST RESULTS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          allTestsCompleted ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Logout button - more subtle
                Container(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    icon: Icon(Icons.logout),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text('LOGOUT'),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.withOpacity(0.5)),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper methods for UI components
  Widget _buildProgressIndicator() {
    int completedTests = [
      test1Completed,
      test2Completed,
      test3Completed,
      test4Completed,
    ].where((test) => test).length;
    double progress = completedTests / 4;

    return Container(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 8,
        backgroundColor: Colors.white.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  int _calculateProgress() {
    int completedTests = [
      test1Completed,
      test2Completed,
      test3Completed,
      test4Completed,
    ].where((test) => test).length;
    return (completedTests / 4 * 100).round();
  }

  Widget _buildTestCard({
    required String title,
    required IconData icon,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: isCompleted ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCompleted ? 'COMPLETED' : 'PENDING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
