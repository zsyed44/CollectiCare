import 'package:flutter/material.dart';
import 'package:flutter_application/services/api_service.dart';

class InitialScreening extends StatefulWidget {
  String patientID;
  InitialScreening({required this.patientID});

  @override
  _InitialScreeningState createState() => _InitialScreeningState();
}

class _InitialScreeningState extends State<InitialScreening> {
  //Ophthalmology History
  // Loss of Vision
  bool hasVisionLoss = false;
  String? selectedEyeVision;
  String? onsetVision;
  String? hasVisionPain;
  String? durationVision;

  // Redness
  bool hasRedness = false;
  String? selectedEyeRedness;
  String? onsetRedness;
  String? hasRednessPain;
  String? durationRedness;

  // Watering
  bool hasWatering = false;
  String? selectedEyeWatering;
  String? onsetWatering;
  String? hasWateringPain;
  String? durationWatering;
  String? dischargeType;

  // Itching
  bool hasItching = false;
  String? itchingEye;
  String? itchingDuration;

  // Pain
  bool hasPain = false;
  String? painEye;
  String? painOnset;
  String? painDuration;

  //Systemic History
  bool HTN = false;
  bool DM = false;
  bool heartDisease = false;

  //Allergy History
  bool allergyDrop = false;
  bool allergyTablet = false;
  bool seasonalAllergies = false;

  //Contact Lenses History
  bool contactLenses = false;
  String? contactLensesDuration;
  String? contactLensesFrequency;

  //Eye Surgical History
  bool retinaLaser = false;
  bool cataractSurgery = false;

  Future<void> _submitTest() async {
    try {
      final response = await ApiService.post("systemic/add", {
        "patientID": widget.patientID,
        "HTN": HTN,
        "DM": DM,
        "heartDisease": heartDisease
      });

      print('API response: $response');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    }
    try {
      final response = await ApiService.post("allergy/add", {
        "patientID": widget.patientID,
        "allergyDrops": allergyDrop,
        "allergyTablets": allergyTablet,
        "seasonalAllergies": seasonalAllergies
      });

      print('API response: $response');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    }
    try {
      final response = await ApiService.post("contactlense/add", {
        "patientID": widget.patientID,
        "frequency": contactLensesFrequency,
        "usesContactLenses": contactLenses,
        "yearsOfUse": contactLensesDuration
      });

      print('API response: $response');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    }
  }

  void updateState(String category, String value) {
    setState(() {
      //Ophthalmology History
      if (category == "eyeVision") selectedEyeVision = value;
      if (category == "onsetVision") onsetVision = value;
      if (category == "painVision") hasVisionPain = value;
      if (category == "durationVision") durationVision = value;

      if (category == "eyeRedness") selectedEyeRedness = value;
      if (category == "onsetRedness") onsetRedness = value;
      if (category == "painRedness") hasRednessPain = value;
      if (category == "durationRedness") durationRedness = value;

      if (category == "eyeWatering") selectedEyeWatering = value;
      if (category == "onsetWatering") onsetWatering = value;
      if (category == "painWatering") hasWateringPain = value;
      if (category == "durationWatering") durationWatering = value;
      if (category == "dischargeType") dischargeType = value;

      if (category == "itchingEye") itchingEye = value;
      if (category == "itchingDuration") itchingDuration = value;

      if (category == "painEye") painEye = value;
      if (category == "painOnset") painOnset = value;
      if (category == "painDuration") painDuration = value;
    });
  }

  Widget buildToggleButton(
      String category, List<String> options, String? selectedValue) {
    return Row(
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ChoiceChip(
            label: Text(option,
                style: TextStyle(
                    color:
                        selectedValue == option ? Colors.white : Colors.black)),
            selected: selectedValue == option,
            onSelected: (selected) {
              if (selected) updateState(category, option);
            },
            selectedColor: Colors.blue.shade700, // Deep blue when selected
            backgroundColor:
                Colors.grey.shade300, // Light grey when not selected
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget buildRowToggleButton(String label, String category,
      List<String> options, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0), // Indent sub-questions
      child: Row(
        children: [
          SizedBox(
            width: 150, // Fixed width for labels for alignment
            child: Text(label, style: TextStyle(fontSize: 16)),
          ),
          SizedBox(width: 20), // Space between label and buttons
          buildToggleButton(category, options, selectedValue),
        ],
      ),
    );
  }

  Widget buildYesNoQuestion(
      String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Text("Yes", style: TextStyle(color: Colors.blue)),
            Checkbox(
              value: value,
              onChanged: (newValue) => setState(() => onChanged(newValue!)),
              activeColor: Colors.blue, // Blue checkboxes
            ),
            Text("No", style: TextStyle(color: Colors.blue)),
            Checkbox(
              value: !value,
              onChanged: (newValue) => setState(() => onChanged(!newValue!)),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Initial Screening Test")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Bold Text with size 18
            Text("Ophthalmology History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Loss of Vision (Main Question)
            buildYesNoQuestion("Loss of Vision", hasVisionLoss, (value) {
              hasVisionLoss = value;
              if (!hasVisionLoss) {
                selectedEyeVision =
                    onsetVision = durationVision = hasVisionPain = null;
              }
            }),

            if (hasVisionLoss) ...[
              SizedBox(height: 10),
              buildRowToggleButton("Which Eye(s)", "eyeVision",
                  ["R", "L", "Both"], selectedEyeVision),
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Onset", "onsetVision", ["Sudden", "Gradual"], onsetVision),
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Pain", "painVision", ["Yes", "No"], hasVisionPain),
              SizedBox(height: 10),
              buildRowToggleButton("Duration", "durationVision",
                  ["<2 Years", "2-5 Years", "5+ Years"], durationVision),
              //add text size 20
            ],

            SizedBox(height: 15),

            // Redness (Main Question)
            buildYesNoQuestion("Redness", hasRedness, (value) {
              hasRedness = value;
              if (!hasRedness) {
                selectedEyeRedness =
                    onsetRedness = durationRedness = hasRednessPain = null;
              }
            }),

            if (hasRedness) ...[
              SizedBox(height: 10),
              buildRowToggleButton("Which Eye(s)", "eyeRedness",
                  ["R", "L", "Both"], selectedEyeRedness),
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Onset", "onsetRedness", ["Sudden", "Gradual"], onsetRedness),
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Pain", "painRedness", ["Yes", "No"], hasRednessPain),
              SizedBox(height: 10),
              buildRowToggleButton("Duration", "durationRedness",
                  ["<1 Week", "1-4 Weeks", "4+ Weeks"], durationRedness),
            ],

            SizedBox(height: 15),

            // Watering (Main Question)
            buildYesNoQuestion("Watering", hasWatering, (value) {
              hasWatering = value;
              if (!hasWatering) {
                selectedEyeWatering = onsetWatering =
                    durationWatering = hasWateringPain = dischargeType = null;
              }
            }),

            if (hasWatering) ...[
              SizedBox(height: 10),
              buildRowToggleButton("Which Eye(s)", "eyeWatering",
                  ["R", "L", "Both"], selectedEyeWatering),
              SizedBox(height: 10),
              buildRowToggleButton("Onset", "onsetWatering",
                  ["Sudden", "Gradual"], onsetWatering),
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Pain", "painWatering", ["Yes", "No"], hasWateringPain),
              SizedBox(height: 10),
              buildRowToggleButton("Duration", "durationWatering",
                  ["<1 Week", "1-4 Weeks", "4+ Weeks"], durationWatering),
              SizedBox(height: 10),
              buildRowToggleButton("Discharge Type", "dischargeType",
                  ["Clear", "Sticky"], dischargeType),
            ],

            SizedBox(height: 15),

            // Itching (Main Question)
            buildYesNoQuestion("Itching", hasItching, (value) {
              hasItching = value;
              if (!hasItching) {
                itchingEye = itchingDuration = null;
              }
            }),

            if (hasItching) ...[
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Which Eye(s)", "itchingEye", ["R", "L", "Both"], itchingEye),
              SizedBox(height: 10),
              buildRowToggleButton("Duration", "itchingDuration",
                  ["<1 Week", "1-4 Weeks", "4+ Weeks"], itchingDuration),
            ],

            SizedBox(height: 15),

            // Pain (Main Question)
            buildYesNoQuestion("Pain", hasPain, (value) {
              hasPain = value;
              if (!hasPain) {
                painEye = painOnset = painDuration = null;
              }
            }),

            if (hasPain) ...[
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Which Eye(s)", "painEye", ["R", "L", "Both"], painEye),
              SizedBox(height: 10),
              buildRowToggleButton(
                  "Onset", "painOnset", ["Sudden", "Gradual"], painOnset),
              SizedBox(height: 10),
              buildRowToggleButton("Duration", "painDuration",
                  ["<1 Week", "1-4 Weeks", "4+ Weeks"], painDuration),
            ],
            SizedBox(height: 20),

            Text("Systemic History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            buildYesNoQuestion("Hypertension", HTN, (value) {
              HTN = value;
            }),
            SizedBox(height: 15),

            buildYesNoQuestion("Diabetes Mellitus", DM, (value) {
              DM = value;
            }),
            SizedBox(height: 15),

            buildYesNoQuestion("Heart Disease", heartDisease, (value) {
              heartDisease = value;
            }),
            SizedBox(height: 20),

            Text("Allergy History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            buildYesNoQuestion("Allergy to Eye Drops", allergyDrop, (value) {
              allergyDrop = value;
            }),
            SizedBox(height: 15),

            buildYesNoQuestion("Allergy to Tablets", allergyTablet, (value) {
              allergyTablet = value;
            }),
            SizedBox(height: 15),

            buildYesNoQuestion("Seasonal Allergies", seasonalAllergies,
                (value) {
              seasonalAllergies = value;
            }),
            SizedBox(height: 20),

            Text("Contact Lenses History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            buildYesNoQuestion("Wears Contact Lenses", contactLenses, (value) {
              contactLenses = value;
              if (!contactLenses) {
                contactLensesDuration = contactLensesFrequency = null;
              }
            }),
            SizedBox(height: 15),

            if (contactLenses) ...[
              SizedBox(height: 10),
              buildRowToggleButton("Duration of Use", "contactLensesDuration",
                  ["<1 Year", "1-5 Years", "5+ Years"], contactLensesDuration),
              SizedBox(height: 10),
              buildRowToggleButton("Frequency of Use", "contactLensesFrequency",
                  ["Daily", "Weekly", "Monthly"], contactLensesFrequency),
            ],

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Returns true when submitted
                _submitTest();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
