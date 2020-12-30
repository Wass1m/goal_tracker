import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goaltracker/models/profile.dart';
import 'package:goaltracker/screens/auth/welcome.dart';
import 'package:goaltracker/screens/home/home.dart';
import 'package:goaltracker/services/fire/auth.dart';
import 'package:goaltracker/services/fire/global.dart';
import 'package:goaltracker/wrapp_user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return WrapperUser();
  }
}
