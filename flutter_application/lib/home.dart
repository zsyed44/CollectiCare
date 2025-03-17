import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class Home extends StatelessWidget {
    final VoidCallback toggleTheme;
  final bool isDarkMode;

  const Home({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text('WELCOME'),
          automaticallyImplyLeading: false, // Hide back arrow in AppBar
          actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: toggleTheme,
          ),
        ],
        ),
        body: Center(
          //creating 2 buttons for login and register
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  //navigate to login page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                },
                child: Text('Register'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
