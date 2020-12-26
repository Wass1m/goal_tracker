import 'package:flutter/material.dart';
import 'package:goaltracker/screens/auth/welcome.dart';
import 'package:goaltracker/services/fire/auth.dart';
import 'package:goaltracker/style/style.dart';

class HomeScreen extends StatelessWidget {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You made it ! welcome '),
              RaisedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
                child: Text(
                  'Logout',
                  style: SansHeading,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
