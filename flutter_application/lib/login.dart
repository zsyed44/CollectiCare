import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
//import 'dart:typed_data';
import 'patient_dashboard.dart';
import 'services/api_service.dart';
import 'temporary_page.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

String thisCity = selectedCity;

final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
  performanceMode: FaceDetectorMode.fast,
  enableClassification: true,
  enableTracking: false,
));
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Interpreter? interpreter;

  @override
  void initState() {
    super.initState();
    loadModel(); // Load the model in the init state
  }

  // Method to load the TensorFlow Lite model
  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
    print('Model loaded successfully');
  }

  // Method to detect faces in the image using ML Kit
  Future<List<Face>> detectFaces(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faces = await faceDetector.processImage(inputImage);
    return faces;
  }

  // Close detection tool
  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  Future<Uint8List> cropImage(Uint8List imageBytes, Rect rect) async {
    final data = await decodeImageFromList(imageBytes);
    final croppedImage = await data.toByteData(format: ui.ImageByteFormat.png);

    if (croppedImage == null) {
      throw Exception('Failed to crop image');
    }
    final byteData = croppedImage.buffer.asUint8List();

    return byteData;
  }

  Future<Uint8List> cropFaceToBitmap(Face face, Uint8List imageBytes) async {
    final rect = face.boundingBox;
    final croppedImage = await cropImage(imageBytes, rect);
    return croppedImage;
  }

  Future<List<double>> getFaceEmbedding(Uint8List faceImageBytes) async {
    // Load the image using the image package
    img.Image? image = img.decodeImage(Uint8List.fromList(faceImageBytes));

    if (image == null) {
      throw Exception("Failed to decode image.");
    }

    // Resize the image to 112x112 (standard for MobileFaceNet input)
    img.Image resizedImage = img.copyResize(image, width: 112, height: 112);

    // Prepare the input buffer for TensorFlow Lite model
    List<double> inputList = [];

    // Normalize the image to [-1, 1] and create a flattened list of doubles
    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        int pixel = resizedImage.getPixel(x, y);  // Get pixel at (x, y)

        // Extract RGB values from the pixel and normalize to [-1, 1]
        double r = (img.getRed(pixel) - 127.5) / 127.5;
        double g = (img.getGreen(pixel) - 127.5) / 127.5;
        double b = (img.getBlue(pixel) - 127.5) / 127.5;

        inputList.add(r);
        inputList.add(g);
        inputList.add(b);
      }
    }

    // Load the TensorFlow Lite model from assets
    final interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');

    interpreter.allocateTensors();

    var inputShape = interpreter.getInputTensor(0).shape;
    var inputBuffer = inputList.reshape(inputShape);

    var outputBuffer = List.filled(1 * 192, 0.0).reshape([1, 192]); // MobileFaceNEt requires [1, 192] sized tensor (we are using a List representation)

    interpreter.run(inputBuffer, outputBuffer);
    //print("Output: " + outputBuffer.toString());

    return outputBuffer[0].cast<double>();
  }
  
  Uint8List? _imageData;
  final picker = ImagePicker();
  bool _isLoggingIn = false;
  final _idController = TextEditingController();

  String name = '', dob = '', eyeStatus = '';
  int age = 0;
  List<double> imageEmbedding = [];

  Future<void> fetchAndSetValues(patientID) async {
    try {
      final response = await ApiService.get('patient/$patientID/summary');
      if (response == null || response.containsKey("error")) {
        throw Exception("Failed to load data");
      }
      print(response);

      name = response["Name"];
      dob = response["DOB"].split("T")[0]; // The split is to remove the time component from the DOB
      eyeStatus = response["Eye Status"];
      age = DateTime.now().year - int.parse(dob.substring(0, 4));
      imageEmbedding = response["ImageEmbedding"];
      print("FETCH: Name: $name, DOB: $dob, Eye Status: $eyeStatus, Age: $age, Image Embedding: $imageEmbedding");
    } catch (e) {
      print("Error: $e");
    }
  }

  bool compareEmbeddings(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) return false;

    double dotProduct = 0;
    double norm1 = 0;
    double norm2 = 0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }

    double similarity = dotProduct / (sqrt(norm1) * sqrt(norm2)); // sqrt is now available
    print('Cosine Similarity: $similarity');

    return similarity > 0.70; // You can adjust the threshold (0.85) as needed
  }

  Future<void> login(List<double> loginImage) async {
    //if (_imageData == null) return;

    setState(() => _isLoggingIn = true);

    try {
      String id = _idController.text;
      final response = await ApiService.get('patient/$id/$thisCity');

      if (response != null && response['patientID'] != null) {
        try{
          final response2 = await ApiService.get('patient/$id/summary');
          print("LOGIN: $response2");

          List<double> newImage = response2["ImageEmbedding"].cast<double>();

          if (newImage.isNotEmpty) {
            bool isMatch = await compareEmbeddings(newImage, loginImage);
            print("Is Match: $isMatch");
            if (!isMatch) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Face not recognized')),
              );
              return;
            }
            else {
              await Future.delayed(Duration(seconds: 3)); // Simulate login delay
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientDashboard(
                        patientID: id,
                        name: response2["Name"],
                        dob: response2["DOB"].split("T")[0],
                        eyeStatus: response2["Eye Status"],
                        age: age)),
              );
            }
          } 
        }
        catch (e) {
          print("Error: $e");
        }

       
      } else {
        // If the patient is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient not found or does not exist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      // Detect faces in the image
      final faces = await detectFaces(pickedFile.path);

      await Future.delayed(Duration(seconds: 1)); // Simulate login delay

      final croppedFace = await cropFaceToBitmap(faces[0], bytes);
      print(croppedFace);
      final faceEmbedding = await getFaceEmbedding(croppedFace);
      print("Face Embedding: " + faceEmbedding.toString());

      setState(() {
        _imageData = bytes;
        _isLoggingIn = true; // Show loading state
      });

      login(faceEmbedding); // Call the login function
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: 'Enter ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoggingIn ? null : pickImage,
              child: Text(
                  _isLoggingIn ? 'Logging in...' : 'Capture Photo to Login'),
            ),
            if (_imageData != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.memory(_imageData!, height: 100),
              ),
          ],
        ),
      ),
    );
  }
}
