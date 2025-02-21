import 'package:flutter/material.dart';
import 'package:flutter_application/home.dart';
//import 'package:flutter_application/home.dart';
//import 'package:flutter_application/test1.dart';
import 'package:flutter_application/test1b.dart';
import 'package:flutter_application/dashboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}
