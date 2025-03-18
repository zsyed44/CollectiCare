import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'analysis.dart';

class CampWorker {
  final String workerID;
  final String name;
  final String role;

  CampWorker({required this.workerID, required this.name, required this.role});

  factory CampWorker.fromJson(Map<String, dynamic> json) {
    return CampWorker(
      workerID: json.containsKey('workerID') ? json['workerID'].toString() : 'N/A',
      name: json.containsKey('name') ? json['name'].toString() : 'Unknown',
      role: json.containsKey('role') ? json['role'].toString() : 'No Role',
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

  @override
  void initState() {
    super.initState();
    fetchCampWorkers();
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

Future<void> addCampWorker(String workerID, String name, String role) async {
  try {
    await ApiService.post('campWorkers', {
      "workerID": workerID,
      "name": name,
      "role": role,
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
    TextEditingController workerIDController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController roleController = TextEditingController();

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

                if (workerID.isNotEmpty && name.isNotEmpty && role.isNotEmpty) {
                  addCampWorker(workerID, name, role);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Camp Workers"),
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
    );
  }
}
