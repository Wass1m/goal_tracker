import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goaltracker/screens/auth/welcome.dart';
import 'package:goaltracker/screens/home/home.dart';
import 'package:goaltracker/services/fire/auth.dart';
import 'package:provider/provider.dart';

class WrapperUser extends StatefulWidget {
  @override
  _WrapperUserState createState() => _WrapperUserState();
}

class _WrapperUserState extends State<WrapperUser> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return user == null ? WelcomeScreen() : HomeScreen();
  }
}
