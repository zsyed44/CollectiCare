import 'package:flutter/material.dart';
import 'home.dart';
import 'temporary_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollectiCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner

      // Set TempPage as the first page, but make "/" refer to Home
      initialRoute: '/temp',
      
      routes: {
        '/': (context) => Home(), // Make "/" point to Home
        '/home': (context) => Home(),
        '/temp': (context) => TempPage(),
      },
    );
  }
}
