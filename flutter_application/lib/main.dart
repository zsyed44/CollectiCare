import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'temporary_page.dart';
import 'package:flutter_application/dashboard.dart';
import 'admin_dashboard.dart';
import 'healthWorker_login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isDarkMode = true; // Default to dark mode

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollectiCare',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? getThemeData(true) : getThemeData(false), // Apply dynamic theme

      initialRoute: '/login',
      routes: {
        '/admin-dashboard': (context) => AdminPage(),
        '/': (context) => Home(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/home': (context) => Home(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/temp': (context) => TempPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/login': (context) => HealthWorkerLoginPage()
      },
    );
  }
}

ThemeData getThemeData(bool isDarkMode) {
  return ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
      isDarkMode
          ? Typography.whiteCupertino.apply(bodyColor: Colors.white)
          : Typography.blackCupertino.apply(bodyColor: Colors.black),
    ),
    inputDecorationTheme: getGlobalInputTheme(isDarkMode), // Apply dynamic input theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDarkMode ? Colors.transparent : Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
    ),
  );
}

InputDecorationTheme getGlobalInputTheme(bool isDarkMode) {
  return InputDecorationTheme(
    filled: true,
    fillColor: isDarkMode ? Colors.white24 : Colors.white, // Darker in dark mode, white in light mode
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.blueAccent, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.blueAccent, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
    ),
    hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black45), // Dark hint in light mode
    labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // White label in dark mode, black in light mode
    floatingLabelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.blueAccent), // Consistent label visibility
  );
}
