import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'analysis.dart';

class CampWorker {
  final String workerID;
  final String name;
  final String role;
  final String password;
  String location;

  CampWorker({
    required this.workerID,
    required this.name,
    required this.role,
    required this.password,
    required this.location,
  });

  factory CampWorker.fromJson(Map<String, dynamic> json) {
    return CampWorker(
      workerID:
          json.containsKey('workerID') ? json['workerID'].toString() : 'N/A',
      name: json.containsKey('name') ? json['name'].toString() : 'Unknown',
      role: json.containsKey('role') ? json['role'].toString() : 'No Role',
      password: json.containsKey('password')
          ? json['password'].toString()
          : 'No Password',
      location: json.containsKey('location')
          ? json['location'].toString()
          : 'Unknown',
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<CampWorker> workers = [];
  bool isLoading = true;
  String? errorMessage;

  // Define available locations
  final List<String> availableLocations = ["London", "Montreal", "Toronto"];

  final TextEditingController workerIDController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    fetchCampWorkers();

    // Add listeners to update the password dynamically
    workerIDController.addListener(_updatePassword);
    nameController.addListener(_updatePassword);
  }

  @override
  void dispose() {
    workerIDController.dispose();
    nameController.dispose();
    roleController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchCampWorkers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final response = await ApiService.get('campWorkers');
      print("API Response: $response");

      if (response == null || response is! List) {
        throw Exception("Invalid response format");
      }

      List<CampWorker> fetchedWorkers = response
          .map<CampWorker>((worker) => CampWorker.fromJson(worker))
          .toList();

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

  // Update the location of a worker in the database
  Future<void> updateWorkerLocation(String workerID, String newLocation) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Updating location...")),
      );
      
      // Make API call to update location
      await ApiService.put('campWorkers/$workerID/updateLocation', {
        "location": newLocation,
      });

      // Update local state after successful API call
      setState(() {
        final workerIndex = workers.indexWhere((w) => w.workerID == workerID);
        if (workerIndex != -1) {
          workers[workerIndex].location = newLocation;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Worker's location updated to $newLocation!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update location: $e")),
      );
      
      // Refresh the list to reset to previous values
      fetchCampWorkers();
    }
  }

  // Function to generate password based on workerID and name
  String generatePassword(String workerID, String name) {
    if (workerID.isEmpty || name.isEmpty || name.length < 3) {
      return '';
    }
    
    // Get last 3 digits of workerID and combine with the name
    String lastThreeDigits = workerID.length > 3
        ? workerID.substring(workerID.length - 3)
        : workerID;
    return '${name.substring(0, name.length >= 3 ? 3 : name.length)}$lastThreeDigits'; // Example: "Joh123"
  }

  // Update password dynamically as name or workerID changes
  void _updatePassword() {
    String generatedPassword =
        generatePassword(workerIDController.text, nameController.text);
    passwordController.text = generatedPassword;
    passwordController.selection = TextSelection.collapsed(
        offset: passwordController.text.length); // Keep cursor at the end
  }

  Future<void> addCampWorker(String workerID, String name, String role,
      String password, String location) async {
    try {
      await ApiService.post('campWorkers', {
        "workerID": workerID,
        "name": name,
        "role": role,
        "password": password,
        "location": location,
      });

      print("Worker added successfully!");

      Navigator.pop(context); // Close the dialog
      
      // Clear text fields after adding
      workerIDController.clear();
      nameController.clear();
      roleController.clear();
      passwordController.clear();
      selectedLocation = null;
      
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
    // Clear previous values first
    workerIDController.clear();
    nameController.clear();
    roleController.clear();
    passwordController.clear();
    selectedLocation = null;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Add Camp Worker"),
              content: SingleChildScrollView(
                child: Column(
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
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Location"),
                      value: selectedLocation,
                      hint: Text("Select Location"),
                      onChanged: (newValue) {
                        setDialogState(() {
                          selectedLocation = newValue;
                        });
                      },
                      items: availableLocations
                          .map<DropdownMenuItem<String>>((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: "Generated Password"),
                      readOnly: true,
                    ),
                  ],
                ),
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

                    if (workerID.isNotEmpty &&
                        name.isNotEmpty &&
                        role.isNotEmpty &&
                        password.isNotEmpty &&
                        selectedLocation != null) {
                      addCampWorker(workerID, name, role, password, selectedLocation!);
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
          }
        );
      },
    );
  }

  void logout() {
    // You can add logic to remove session data or tokens here
    Navigator.pushReplacementNamed(context, '/home');
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
                  child: RefreshIndicator(
                    onRefresh: fetchCampWorkers,
                    child: ListView.builder(
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        
                        // Ensure worker's location is in the available locations list
                        // If not, default to the first location
                        String displayLocation = worker.location;
                        if (!availableLocations.contains(displayLocation)) {
                          displayLocation = availableLocations.isNotEmpty ? 
                                           availableLocations[0] : "Unknown";
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        worker.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Role: ${worker.role}",
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      Text(
                                        "ID: ${worker.workerID}",
                                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Location:", style: TextStyle(fontSize: 14)),
                                    DropdownButton<String>(
                                      value: displayLocation,
                                      onChanged: (String? newValue) {
                                        if (newValue != null && newValue != worker.location) {
                                          updateWorkerLocation(worker.workerID, newValue);
                                        }
                                      },
                                      items: availableLocations
                                          .map<DropdownMenuItem<String>>((String city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(city),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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