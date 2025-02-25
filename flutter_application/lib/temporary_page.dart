import 'package:flutter/material.dart';
import 'home.dart';

String selectedCity = "";

class TempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
          automaticallyImplyLeading: false, // Remove back arrow
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  selectedCity = "London";
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text("Login to London"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  selectedCity = "Montreal";
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text("Login to Montreal"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  selectedCity = "Toronto";
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text("Login to Toronto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
