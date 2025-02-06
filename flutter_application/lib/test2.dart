import 'package:flutter/material.dart';

class Test2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test 2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Returns true when submitted
              },
              child: Text('Submit Test 2'),
            ),
          ],
        ),
      ),
    );
  }
}
