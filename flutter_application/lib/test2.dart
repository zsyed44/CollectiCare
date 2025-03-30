import 'package:flutter/material.dart';
import 'dart:math';
import 'patient_dashboard.dart';
import 'package:flutter_application/services/api_service.dart';

class ImageEyeTest extends StatefulWidget {
  // const ImageEyeTest({super.key});

  String patientID;
  ImageEyeTest({required this.patientID});

  @override
  _EyeTestState createState() => _EyeTestState();
}

class _EyeTestState extends State<ImageEyeTest> {
  final Map<String, String> imagesForEyeTest = {
    'assets/eyeRight.png': "right",
    'assets/eyeLeft.png': "left",
    'assets/eyeUp.png': "up",
    'assets/eyeDown.png': "down"
  };

  late List<String> generatedImages;
  late List<String> swipeDirection;
  final PageController _pageController = PageController();

  int _rightEyeScore = 0;
  int _leftEyeScore = 0;

  bool _changeEye = false;

  @override
  void initState() {
    super.initState();
    _generateRandomImages();
  }

  void _generateRandomImages() {
    final Random random = Random();
    generatedImages = List.generate(
        10,
        (index) => imagesForEyeTest.keys
            .elementAt(random.nextInt(imagesForEyeTest.length)));
    swipeDirection = List.filled(10, "");
  }

  void _restartTest() {
    _generateRandomImages();
    setState(() {});
    Future.delayed(Duration(milliseconds: 500), () {
      _pageController.jumpToPage(0);
    });
    _changeEye = true;
  }

  void _handleSwipes(DragEndDetails details, int index) {
    if (details.primaryVelocity == null) return;

    String detectedDirection = "";
    if (details.primaryVelocity! > 0) {
      detectedDirection = "right";
    } else {
      detectedDirection = "left";
    }

    if (details.velocity.pixelsPerSecond.dy.abs() >
        details.velocity.pixelsPerSecond.dx.abs()) {
      detectedDirection =
          details.velocity.pixelsPerSecond.dy > 0 ? "down" : "up";
    }

    setState(() {
      swipeDirection[index] = detectedDirection;
      if (detectedDirection == imagesForEyeTest[generatedImages[index]] &&
          !_changeEye) {
        _leftEyeScore++;
      } else if (detectedDirection ==
              imagesForEyeTest[generatedImages[index]] &&
          _changeEye) {
        _rightEyeScore++;
      }
    });

    if (index < generatedImages.length) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  Future<void> _submitTest() async {
    String eyeScore = "$_leftEyeScore/$_rightEyeScore";
    print("$_leftEyeScore/$_rightEyeScore");

    try {
      final response = await ApiService.put("patient/updateEye", {
        "patientID": widget.patientID,
        "fieldName": "EyeStatus",
        "newValue": eyeScore
      });

      print('API response: $response');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('LE: $_leftEyeScore | RE: $_rightEyeScore')),
        body: PageView.builder(
            controller: _pageController,
            itemCount: generatedImages.length + 1,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == generatedImages.length) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(!_changeEye ? "Test Other Eye" : "Complete Test",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_changeEye) {
                          _submitTest();
                          Navigator.pop(context,
                              true); //Once connection to db is complete this is where the function to send to db will be
                        } else {
                          _restartTest();
                        }
                      },
                      child: Text(!_changeEye ? "Restart Test" : "Submit Test"),
                    )
                  ],
                ));
              }
              double scaleFactor = pow(0.707, index).toDouble();
              return GestureDetector(
                  onHorizontalDragEnd: (details) =>
                      _handleSwipes(details, index),
                  onVerticalDragEnd: (details) => _handleSwipes(details, index),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                        child: Transform.scale(
                      scale: scaleFactor,
                      child: Image.asset(generatedImages[index],
                          fit: BoxFit.cover),
                    )),
                  ));
            }));
  }
}
