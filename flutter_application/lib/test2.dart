import 'package:flutter/material.dart';

class ImageEyeTest extends StatefulWidget {
  const ImageEyeTest({super.key});

  @override
  _EyeTestState createState() => _EyeTestState();
}

class _EyeTestState extends State<ImageEyeTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Perform Eye Test')),
        body: PageView(
          children: [
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            )
          ],
        ));
  }
}
