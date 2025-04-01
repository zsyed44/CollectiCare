import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'analysis.dart';

class CampWorker {
  final String workerID;
  final String name;
  final String role;
  final String password;

  CampWorker({
    required this.workerID,
    required this.name,
    required this.role,
    required this.password,
  });

  factory CampWorker.fromJson(Map<String, dynamic> json) {
    return CampWorker(
      workerID: json.containsKey('workerID') ? json['workerID'].toString() : 'N/A',
      name: json.containsKey('name') ? json['name'].toString() : 'Unknown',
      role: json.containsKey('role') ? json['role'].toString() : 'No Role',
      password: json.containsKey('password') ? json['password'].toString() : 'No Password',
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<CampWorker> workers = [];
  Map<String, String> selectedCities = {};
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController workerIDController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCampWorkers();

    // Add listeners to update the password dynamically
    workerIDController.addListener(_updatePassword);
    nameController.addListener(_updatePassword);
  }

  Future<void> fetchCampWorkers() async {
    try {
      final response = await ApiService.get('campWorkers');
      print("API Response: $response");

      if (response == null || response is! List) {
        throw Exception("Invalid response format");
      }

      List<CampWorker> fetchedWorkers = response
          .map<CampWorker>((worker) => CampWorker.fromJson(worker))
          .toList();

      if (fetchedWorkers.isEmpty) {
        throw Exception("No workers found");
      }

      setState(() {
        workers = fetchedWorkers;
        isLoading = false;
      });

      print("Workers count: ${workers.length}");
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching workers: $e";
      });
    }
  }

  // Function to generate password based on workerID and name
  String generatePassword(String workerID, String name) {
    // Get last 3 digits of workerID and combine with the name
    String lastThreeDigits = workerID.length > 3 ? workerID.substring(workerID.length - 3) : workerID;
    return '${name.substring(0, 3)}$lastThreeDigits';  // Example: "Joh123"
  }

  // Update password dynamically as name or workerID changes
  void _updatePassword() {
    String generatedPassword = generatePassword(workerIDController.text, nameController.text);
    passwordController.text = generatedPassword;
    passwordController.selection = TextSelection.collapsed(offset: passwordController.text.length); // Keep cursor at the end
  }

  Future<void> addCampWorker(String workerID, String name, String role, String password) async {
    try {
      await ApiService.post('campWorkers', {
        "workerID": workerID,
        "name": name,
        "role": role,
        "password": password,
      });

      print("Worker added successfully!");

      Navigator.pop(context); // Close the dialog
      fetchCampWorkers(); // Refresh list after adding

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camp Worker Added Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add worker: $e")),
      );
    }
  }

  void showAddWorkerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Camp Worker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: workerIDController,
                decoration: InputDecoration(labelText: "Worker ID"),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: roleController,
                decoration: InputDecoration(labelText: "Role"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Generated Password"),
                readOnly: true,  // Make it read-only as the password is auto-generated
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String workerID = workerIDController.text.trim();
                String name = nameController.text.trim();
                String role = roleController.text.trim();
                String password = passwordController.text.trim();

                if (workerID.isNotEmpty && name.isNotEmpty && role.isNotEmpty && password.isNotEmpty) {
                  addCampWorker(workerID, name, role, password);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("All fields are required!")),
                  );
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    // You can add logic to remove session data or tokens here
    // For now, we're simply navigating back to the login page
    Navigator.pushReplacementNamed(context, '/home'); // Ensure the login page route is defined
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent the back button from being pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin - Camp Workers"),
          automaticallyImplyLeading: false, // This removes the back button
          actions: [
            IconButton(
              icon: Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalysisPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: showAddWorkerDialog,
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: logout, // This is the logout button
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "List of Camp Workers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage != null)
                Center(
                  child: Text(errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16)))
              else if (workers.isEmpty)
                Center(
                  child: Text("No camp workers available",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (context, index) {
                      final worker = workers[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    worker.name,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    worker.role,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              DropdownButton<String>(
                                value: selectedCities[worker.workerID] ?? "London",
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCities[worker.workerID] = newValue!;
                                  });
                                },
                                items: ["London", "Montreal", "Toronto"]
                                    .map<DropdownMenuItem<String>>((String city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
