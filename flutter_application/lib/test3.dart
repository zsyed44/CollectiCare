import 'package:flutter/material.dart';

class Test3 extends StatelessWidget {
  const Test3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test 3')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Returns true when submitted
              },
              child: Text('Submit Test 3'),
            ),
          ],
        ),
      ),
    );
  }
}
