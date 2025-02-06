import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WELCOME'),
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
    );
  }
}
