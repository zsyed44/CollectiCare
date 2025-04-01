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
      appBar: AppBar(
        title: Text("Initial Screening",
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section intro panel
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medical_information_outlined,
                            color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Medical Questionnaire",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please complete all sections to help us assess your eye health",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Ophthalmology Section
              _buildSectionHeader(
                  "Ophthalmology History", Icons.visibility_outlined),
              SizedBox(height: 16),

              _buildExpandableQuestion(
                "Loss of Vision",
                hasVisionLoss,
                (value) {
                  hasVisionLoss = value;
                  if (!hasVisionLoss) {
                    selectedEyeVision =
                        onsetVision = durationVision = hasVisionPain = null;
                  }
                },
                childrenWidgets: hasVisionLoss
                    ? [
                        _buildRowToggleButton("Which Eye(s)", "eyeVision",
                            ["R", "L", "Both"], selectedEyeVision),
                        _buildRowToggleButton("Onset", "onsetVision",
                            ["Sudden", "Gradual"], onsetVision),
                        _buildRowToggleButton(
                            "Pain", "painVision", ["Yes", "No"], hasVisionPain),
                        _buildRowToggleButton(
                            "Duration",
                            "durationVision",
                            ["<2 Years", "2-5 Years", "5+ Years"],
                            durationVision),
                      ]
                    : [],
              ),

              _buildExpandableQuestion(
                "Redness",
                hasRedness,
                (value) {
                  hasRedness = value;
                  if (!hasRedness) {
                    selectedEyeRedness =
                        onsetRedness = durationRedness = hasRednessPain = null;
                  }
                },
                childrenWidgets: hasRedness
                    ? [
                        _buildRowToggleButton("Which Eye(s)", "eyeRedness",
                            ["R", "L", "Both"], selectedEyeRedness),
                        _buildRowToggleButton("Onset", "onsetRedness",
                            ["Sudden", "Gradual"], onsetRedness),
                        _buildRowToggleButton("Pain", "painRedness",
                            ["Yes", "No"], hasRednessPain),
                        _buildRowToggleButton(
                            "Duration",
                            "durationRedness",
                            ["<1 Week", "1-4 Weeks", "4+ Weeks"],
                            durationRedness),
                      ]
                    : [],
              ),

              _buildExpandableQuestion(
                "Watering",
                hasWatering,
                (value) {
                  hasWatering = value;
                  if (!hasWatering) {
                    selectedEyeWatering = onsetWatering = durationWatering =
                        hasWateringPain = dischargeType = null;
                  }
                },
                childrenWidgets: hasWatering
                    ? [
                        _buildRowToggleButton("Which Eye(s)", "eyeWatering",
                            ["R", "L", "Both"], selectedEyeWatering),
                        _buildRowToggleButton("Onset", "onsetWatering",
                            ["Sudden", "Gradual"], onsetWatering),
                        _buildRowToggleButton("Pain", "painWatering",
                            ["Yes", "No"], hasWateringPain),
                        _buildRowToggleButton(
                            "Duration",
                            "durationWatering",
                            ["<1 Week", "1-4 Weeks", "4+ Weeks"],
                            durationWatering),
                        _buildRowToggleButton("Discharge Type", "dischargeType",
                            ["Clear", "Sticky"], dischargeType),
                      ]
                    : [],
              ),

              _buildExpandableQuestion(
                "Itching",
                hasItching,
                (value) {
                  hasItching = value;
                  if (!hasItching) {
                    itchingEye = itchingDuration = null;
                  }
                },
                childrenWidgets: hasItching
                    ? [
                        _buildRowToggleButton("Which Eye(s)", "itchingEye",
                            ["R", "L", "Both"], itchingEye),
                        _buildRowToggleButton(
                            "Duration",
                            "itchingDuration",
                            ["<1 Week", "1-4 Weeks", "4+ Weeks"],
                            itchingDuration),
                      ]
                    : [],
              ),

              _buildExpandableQuestion(
                "Pain",
                hasPain,
                (value) {
                  hasPain = value;
                  if (!hasPain) {
                    painEye = painOnset = painDuration = null;
                  }
                },
                childrenWidgets: hasPain
                    ? [
                        _buildRowToggleButton("Which Eye(s)", "painEye",
                            ["R", "L", "Both"], painEye),
                        _buildRowToggleButton("Onset", "painOnset",
                            ["Sudden", "Gradual"], painOnset),
                        _buildRowToggleButton("Duration", "painDuration",
                            ["<1 Week", "1-4 Weeks", "4+ Weeks"], painDuration),
                      ]
                    : [],
              ),

              SizedBox(height: 24),

              // Systemic History Section
              _buildSectionHeader("Systemic History", Icons.favorite_outline),
              SizedBox(height: 16),

              Card(
                elevation: 1,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildYesNoToggle("Hypertension", HTN, (value) {
                        HTN = value;
                      }),
                      Divider(height: 24),
                      _buildYesNoToggle("Diabetes Mellitus", DM, (value) {
                        DM = value;
                      }),
                      Divider(height: 24),
                      _buildYesNoToggle("Heart Disease", heartDisease, (value) {
                        heartDisease = value;
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Allergy Section
              _buildSectionHeader("Allergy History", Icons.error_outline),
              SizedBox(height: 16),

              Card(
                elevation: 1,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildYesNoToggle("Allergy to Eye Drops", allergyDrop,
                          (value) {
                        allergyDrop = value;
                      }),
                      Divider(height: 24),
                      _buildYesNoToggle("Allergy to Tablets", allergyTablet,
                          (value) {
                        allergyTablet = value;
                      }),
                      Divider(height: 24),
                      _buildYesNoToggle("Seasonal Allergies", seasonalAllergies,
                          (value) {
                        seasonalAllergies = value;
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Contact Lenses Section
              _buildSectionHeader(
                  "Contact Lenses History", Icons.remove_red_eye_outlined),
              SizedBox(height: 16),

              _buildExpandableQuestion(
                "Wears Contact Lenses",
                contactLenses,
                (value) {
                  contactLenses = value;
                  if (!contactLenses) {
                    contactLensesDuration = contactLensesFrequency = null;
                  }
                },
                childrenWidgets: contactLenses
                    ? [
                        _buildRowToggleButton(
                            "Duration of Use",
                            "contactLensesDuration",
                            ["<1 Year", "1-5 Years", "5+ Years"],
                            contactLensesDuration),
                        _buildRowToggleButton(
                            "Frequency of Use",
                            "contactLensesFrequency",
                            ["Daily", "Weekly", "Monthly"],
                            contactLensesFrequency),
                      ]
                    : [],
              ),

              SizedBox(height: 32),

              // Submit Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, true); // Returns true when submitted
                    _submitTest();
                  },
                  icon: Icon(Icons.check_circle_outline),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'SUBMIT QUESTIONNAIRE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

// Section header with icon
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue.shade800),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
      ],
    );
  }

// Modern toggle chips
  Widget _buildToggleButton(
      String category, List<String> options, String? selectedValue) {
    return Wrap(
      spacing: 10,
      children: options.map((option) {
        return ChoiceChip(
          label: Text(
            option,
            style: TextStyle(
              color: selectedValue == option ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          selected: selectedValue == option,
          onSelected: (selected) {
            if (selected) updateState(category, option);
          },
          selectedColor: Colors.blue.shade700,
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        );
      }).toList(),
    );
  }

// Row with label and toggle buttons
  Widget _buildRowToggleButton(String label, String category,
      List<String> options, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          _buildToggleButton(category, options, selectedValue),
        ],
      ),
    );
  }

// Modern Yes/No toggle with better layout
  Widget _buildYesNoToggle(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() => onChanged(true)),
              child: Text("Yes"),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    value ? Colors.blue.shade700 : Colors.grey.shade200,
                foregroundColor: value ? Colors.white : Colors.black87,
                elevation: value ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => setState(() => onChanged(false)),
              child: Text("No"),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    !value ? Colors.blue.shade700 : Colors.grey.shade200,
                foregroundColor: !value ? Colors.white : Colors.black87,
                elevation: !value ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Expandable question card
  Widget _buildExpandableQuestion(
      String title, bool value, Function(bool) onChanged,
      {required List<Widget> childrenWidgets}) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header with toggle
            _buildYesNoToggle(title, value, onChanged),

            // Conditionally show children with animation
            if (value) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              ...childrenWidgets
                  .map((widget) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: widget,
                      ))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }
}
