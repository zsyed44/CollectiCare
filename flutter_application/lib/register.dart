import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'profile_registration.dart';
import 'services/api_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;


final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
  performanceMode: FaceDetectorMode.fast,
  enableClassification: true,
  enableTracking: false,
));

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Uint8List? _imageBytes;
  List<Face> _faces = [];
  final picker = ImagePicker();
  final TextEditingController _idController = TextEditingController();
  bool _isValidID = false;

  // Method for validating ID format (12-digit check)
  void _validateID(String value) {
    setState(() {
      _isValidID = RegExp(r'^\d{12}$').hasMatch(value);
    });
  }

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

  // Method to pick an image, detect faces, and display bounding boxes
  Future<void> pickImage() async {
    if (!_isValidID) return; // Ensure button can't be clicked when disabled

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
      
      // Automatically navigate to profile registration page after photo upload
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileRegistration(
                  userId: _idController.text,
                  embedding: faceEmbedding,
                )),
      );

      setState(() {
        _imageBytes = bytes;
        _faces = faces; // Store detected faces for drawing bounding boxes
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
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

    // Allocate the input tensor for the model
    // Allocate tensors for the interpreter
    interpreter.allocateTensors();

    // Get input tensor shape and prepare input buffer
    var inputShape = interpreter.getInputTensor(0).shape;
    var inputBuffer = inputList.reshape(inputShape);

    // Prepare the output buffer (output size depends on your model, e.g., 192 for MobileFaceNet)
    var outputBuffer = List.filled(1 * 192, 0.0).reshape([1, 192]);

    // Run inference on the input buffer and get the result in the output buffer
    interpreter.run(inputBuffer, outputBuffer);
    print("Output: " + outputBuffer.toString());

    // Return the embeddings as a list of doubles
    return outputBuffer[0].cast<double>();
  }

  // //Method to get the embedding from the cropped face
  // Future<List<double>> getFaceEmbedding(Uint8List faceImageBytes) async {
  //   var input = faceImageBytes;
  //   print("Input: " + input.toString()); 
  //   var output = List.generate(1, (index) => List.filled(192, 0.0));
  //   print("Output: " + output.toString());

  //   interpreter?.run(input, output);
  //   print("Succesfully ran the model");

  //   return output[0]; // Return the embeddings
  // }

  // Method to crop the face from the image and get the bitmap
  Future<Uint8List> cropFaceToBitmap(Face face, Uint8List imageBytes) async {
    final rect = face.boundingBox;
    final croppedImage = await cropImage(imageBytes, rect);
    return croppedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('REGISTER')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(hintText: 'Enter 12-digit ID Number'),
              keyboardType: TextInputType.number,
              onChanged: _validateID, // Call validation function on input change
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isValidID ? pickImage : null, // Disable button if invalid
              child: Text('Capture Photo to Register Patient'),
            ),
            if (_imageBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: _faces.isEmpty
                    ? Image.memory(_imageBytes!, height: 100) // Show image if no faces detected
                    : ImageWithBoundingBoxes(
                        imagePath: _imageBytes!,
                        faces: _faces, // Pass the detected faces to the widget
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter widget for drawing bounding boxes
class ImageWithBoundingBoxes extends StatelessWidget {
  final Uint8List imagePath;
  final List<Face> faces;

  ImageWithBoundingBoxes({required this.imagePath, required this.faces});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(1200, 1600), // Define the size of the image container
      painter: FaceBoundingBoxPainter(imagePath: imagePath, faces: faces),
    );
  }
}

class FaceBoundingBoxPainter extends CustomPainter {
  final Uint8List imagePath;
  final List<Face> faces;

  FaceBoundingBoxPainter({required this.imagePath, required this.faces});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw bounding boxes around each detected face
    for (final face in faces) {
      final rect = face.boundingBox;
      canvas.drawRect(rect, paint); // Draw bounding box around the face
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
